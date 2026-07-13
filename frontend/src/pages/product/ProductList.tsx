import { Typography, Row, Col, Select, Pagination, Spin, Empty, Breadcrumb } from "antd";
import { useEffect, useState } from "react";
import { useParams, Link } from "react-router-dom";
import { getCategoryProducts, searchProducts } from "../../services/apiCategory";
import ProductCard from "../../components/product/ProductCard";

const { Title } = Typography;
const { Option } = Select;

interface Product {
  id: string | number;
  name: string;
  slug: string;
  image: string;
  price: number;
  sale: number;
}

export default function ProductList() {
  const { slug } = useParams<{ slug?: string }>();
  const [products, setProducts] = useState<Product[]>([]);
  const [categoryName, setCategoryName] = useState<string>("Tất cả sản phẩm");
  const [loading, setLoading] = useState(true);
  const [sort, setSort] = useState<string>("default");
  const [page, setPage] = useState<number>(1);
  const [totalPages, setTotalPages] = useState<number>(1);

  useEffect(() => {
    // Reset page on category slug change
    setPage(1);
  }, [slug]);

  useEffect(() => {
    const fetchProducts = async () => {
      setLoading(true);
      try {
        if (slug) {
          const res = await getCategoryProducts(slug, sort, page);
          if (res?.status === "success" && res?.data) {
            setProducts(res.data.products || []);
            setCategoryName(res.data.category?.name || "Danh mục");
            setTotalPages(res.data.totalPages || 1);
          }
        } else {
          // No slug means show all products
          const res = await searchProducts("", sort, page);
          if (res?.status === "success" && res?.data) {
            setProducts(res.data.products || []);
            setCategoryName("Tất cả sản phẩm");
            setTotalPages(res.data.totalPages || 1);
          }
        }
      } catch (error) {
        console.error("Error fetching product list:", error);
      } finally {
        setLoading(false);
      }
    };
    fetchProducts();
  }, [slug, sort, page]);

  return (
    <div style={{ maxWidth: 1200, margin: "20px auto", padding: "0 20px", textAlign: "left" }}>
      <Breadcrumb style={{ marginBottom: 20 }}>
        <Breadcrumb.Item>
          <Link to="/">Trang chủ</Link>
        </Breadcrumb.Item>
        <Breadcrumb.Item>{categoryName}</Breadcrumb.Item>
      </Breadcrumb>

      <div
        style={{
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
          marginBottom: 24,
          flexWrap: "wrap",
          gap: "12px",
        }}
      >
        <Title level={2} style={{ margin: 0 }}>
          {categoryName}
        </Title>

        <Select
          defaultValue="default"
          style={{ width: 200 }}
          onChange={(val) => setSort(val)}
          size="large"
        >
          <Option value="default">Sắp xếp: Mặc định</Option>
          <Option value="price-asc">Giá: Thấp đến Cao</Option>
          <Option value="price-desc">Giá: Cao đến Thấp</Option>
          <Option value="name-asc">Tên: A-Z</Option>
          <Option value="name-desc">Tên: Z-A</Option>
        </Select>
      </div>

      {loading ? (
        <div style={{ textAlign: "center", padding: "100px 0" }}>
          <Spin size="large" />
        </div>
      ) : products.length === 0 ? (
        <Empty description="Không tìm thấy sản phẩm nào" />
      ) : (
        <>
          <Row gutter={[16, 24]}>
            {products.map((product) => (
              <Col xs={24} sm={12} md={8} lg={6} xl={4.8} key={product.id}>
                <ProductCard product={product} />
              </Col>
            ))}
          </Row>

          <div style={{ textAlign: "center", marginTop: 40 }}>
            <Pagination
              current={page}
              total={totalPages * 10}
              onChange={(p) => setPage(p)}
              showSizeChanger={false}
            />
          </div>
        </>
      )}
    </div>
  );
}
