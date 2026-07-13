import { Card, Typography, Button, InputNumber, Row, Col, Spin, Breadcrumb } from "antd";
import { ShoppingCartOutlined, PlusOutlined, MinusOutlined } from "@ant-design/icons";
import { useEffect, useState } from "react";
import { useParams, Link } from "react-router-dom";
import { toast } from "react-toastify";
import { getProductBySlug } from "../../services/apiProduct";
import { addToCart } from "../../services/apiCart";

const { Title, Paragraph } = Typography;

interface Product {
  id: string | number;
  name: string;
  description: string;
  price: number;
  image: string;
  sale: number;
}

export default function ProductDetail() {
  const { slug } = useParams<{ slug: string }>();
  const [product, setProduct] = useState<Product | null>(null);
  const [quantity, setQuantity] = useState<number>(1);
  const [loading, setLoading] = useState(true);
  const [adding, setAdding] = useState(false);

  useEffect(() => {
    const fetchProduct = async () => {
      if (!slug) return;
      setLoading(true);
      try {
        const res = await getProductBySlug(slug);
        if (res?.status === "success" && res?.data) {
          setProduct(res.data);
        }
      } catch (error) {
        console.error("Error fetching product:", error);
      } finally {
        setLoading(false);
      }
    };
    fetchProduct();
  }, [slug]);

  const handleAddToCart = async () => {
    if (!product) return;
    
    // Check if token exists
    const token = localStorage.getItem('access_token');
    if (!token) {
      toast.warn("Vui lòng đăng nhập để mua sắm!");
      return;
    }

    setAdding(true);
    try {
      await addToCart(product.id, quantity);
      toast.success("Thêm vào giỏ hàng thành công!");
    } catch (error) {
      console.error("Error adding to cart:", error);
      toast.error("Không thể thêm vào giỏ hàng. Vui lòng thử lại!");
    } finally {
      setAdding(false);
    }
  };

  if (loading) {
    return (
      <div style={{ textAlign: "center", padding: "100px 0" }}>
        <Spin size="large" />
      </div>
    );
  }

  if (!product) {
    return (
      <div style={{ textAlign: "center", padding: "50px 0" }}>
        <Title level={3}>Không tìm thấy sản phẩm</Title>
        <Link to="/">
          <Button type="primary" style={{ background: "var(--color-primary)", borderColor: "var(--color-primary)" }}>
            Quay lại trang chủ
          </Button>
        </Link>
      </div>
    );
  }

  const finalPrice = product.sale > 0 ? product.price * (1 - product.sale / 100) : product.price;

  return (
    <div style={{ maxWidth: 1000, margin: "20px auto", padding: "0 20px" }}>
      <Breadcrumb style={{ marginBottom: 20, textAlign: "left" }}>
        <Breadcrumb.Item>
          <Link to="/">Trang chủ</Link>
        </Breadcrumb.Item>
        <Breadcrumb.Item>Chi tiết sản phẩm</Breadcrumb.Item>
        <Breadcrumb.Item>{product.name}</Breadcrumb.Item>
      </Breadcrumb>

      <Card
        style={{
          borderRadius: 16,
          boxShadow: "var(--shadow-md)",
          border: "none",
          textAlign: "left",
        }}
        bodyStyle={{ padding: "40px" }}
      >
        <Row gutter={[32, 32]}>
          {/* IMAGE */}
          <Col xs={24} md={12} style={{ display: "flex", justifyContent: "center", alignItems: "center" }}>
            <img
              src={product.image || "/images/default-product.png"}
              alt={product.name}
              style={{
                width: "100%",
                maxHeight: 400,
                objectFit: "contain",
                borderRadius: 8,
              }}
            />
          </Col>

          {/* CONTENT */}
          <Col xs={24} md={12}>
            <Title level={2} style={{ margin: "0 0 10px 0", fontSize: "28px" }}>
              {product.name}
            </Title>

            <Paragraph type="secondary" style={{ fontSize: "15px", marginBottom: 24, minHeight: "60px" }}>
              {product.description || "Chưa có mô tả chi tiết cho sản phẩm này."}
            </Paragraph>

            <div style={{ marginBottom: 24 }}>
              {product.sale > 0 ? (
                <div>
                  <del style={{ fontSize: "16px", color: "var(--color-text-light)", marginRight: "12px" }}>
                    {product.price.toLocaleString("vi-VN")} VND
                  </del>
                  <span style={{ fontSize: "24px", fontWeight: "bold", color: "var(--color-secondary)" }}>
                    {finalPrice.toLocaleString("vi-VN")} VND
                  </span>
                  <span
                    style={{
                      background: "var(--color-secondary)",
                      color: "white",
                      padding: "2px 8px",
                      borderRadius: "4px",
                      fontSize: "12px",
                      marginLeft: "12px",
                      fontWeight: "bold",
                    }}
                  >
                    Giảm {product.sale}%
                  </span>
                </div>
              ) : (
                <span style={{ fontSize: "24px", fontWeight: "bold", color: "var(--color-primary)" }}>
                  {product.price.toLocaleString("vi-VN")} VND
                </span>
              )}
            </div>

            <div style={{ display: "flex", alignItems: "center", gap: "16px", marginBottom: 30 }}>
              <strong style={{ fontSize: "16px" }}>Số lượng:</strong>
              <div style={{ display: "flex", alignItems: "center", border: "1px solid var(--color-border)", borderRadius: "4px", overflow: "hidden" }}>
                <Button
                  icon={<MinusOutlined />}
                  onClick={() => setQuantity((prev) => Math.max(1, prev - 1))}
                  style={{ border: "none", borderRadius: 0, background: "#f5f5f5" }}
                />
                <InputNumber
                  min={1}
                  value={quantity}
                  onChange={(val) => setQuantity(val || 1)}
                  style={{ border: "none", width: 50, textAlign: "center" }}
                  controls={false}
                />
                <Button
                  icon={<PlusOutlined />}
                  onClick={() => setQuantity((prev) => prev + 1)}
                  style={{ border: "none", borderRadius: 0, background: "#f5f5f5" }}
                />
              </div>
            </div>

            <Button
              type="primary"
              size="large"
              icon={<ShoppingCartOutlined />}
              onClick={handleAddToCart}
              loading={adding}
              style={{
                background: "var(--color-primary)",
                borderColor: "var(--color-primary)",
                borderRadius: "6px",
                height: "48px",
                padding: "0 30px",
                fontWeight: "bold",
                width: "100%",
                maxWidth: 240,
              }}
            >
              Thêm vào giỏ hàng
            </Button>
          </Col>
        </Row>
      </Card>
    </div>
  );
}
