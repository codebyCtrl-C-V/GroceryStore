import { Typography, Row, Col, Tabs, Pagination, Spin, Empty, Breadcrumb } from "antd";
import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { getSaleVegetablesFruits, getSaleProcessed } from "../../services/apiCategory";
import ProductCard from "../../components/product/ProductCard";

const { Title, Paragraph } = Typography;

interface Product {
  id: string | number;
  name: string;
  slug: string;
  image: string;
  price: number;
  sale: number;
  discountPrice?: number;
}

export default function ProductSale() {
  const [activeTab, setActiveTab] = useState<string>("veg-fruits");
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState<number>(1);
  const [totalPages, setTotalPages] = useState<number>(1);

  const fetchSaleProducts = async () => {
    setLoading(true);
    try {
      let res;
      if (activeTab === "veg-fruits") {
        res = await getSaleVegetablesFruits(page);
      } else {
        res = await getSaleProcessed(page);
      }

      if (res?.status === "success" && res?.data) {
        setProducts(res.data.productsSale || []);
        setTotalPages(res.data.totalPages || 1);
      }
    } catch (error) {
      console.error("Error fetching sale products:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    setPage(1);
  }, [activeTab]);

  useEffect(() => {
    fetchSaleProducts();
  }, [activeTab, page]);

  const items = [
    {
      key: "veg-fruits",
      label: "Rau củ & Trái cây giảm giá",
      children: null,
    },
    {
      key: "processed",
      label: "Thực phẩm chế biến giảm giá",
      children: null,
    },
  ];

  return (
    <div style={{ maxWidth: 1200, margin: "20px auto", padding: "0 20px", textAlign: "left" }}>
      <Breadcrumb style={{ marginBottom: 20 }}>
        <Breadcrumb.Item>
          <Link to="/">Trang chủ</Link>
        </Breadcrumb.Item>
        <Breadcrumb.Item>Khuyến mãi hot</Breadcrumb.Item>
      </Breadcrumb>

      <div style={{ marginBottom: 24 }}>
        <Title level={2} style={{ margin: "0 0 8px 0" }}>
          🔥 Khuyến Mãi Hot Nhất
        </Title>
        <Paragraph type="secondary">
          Săn thực phẩm tươi sạch chất lượng cao với giá ưu đãi cực khủng mỗi ngày tại D-Food
        </Paragraph>
      </div>

      <Tabs activeKey={activeTab} items={items} onChange={(key) => setActiveTab(key)} size="large" />

      {loading ? (
        <div style={{ textAlign: "center", padding: "100px 0" }}>
          <Spin size="large" />
        </div>
      ) : products.length === 0 ? (
        <Empty description="Không có sản phẩm nào đang giảm giá" />
      ) : (
        <>
          <Row gutter={[16, 24]} style={{ marginTop: 16 }}>
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
