import { Card, Typography, Row, Col, Button, InputNumber, Space, Spin, Empty, Table } from "antd";
import { DeleteOutlined, ShoppingCartOutlined, ArrowLeftOutlined, CreditCardOutlined, MinusOutlined, PlusOutlined } from "@ant-design/icons";
import { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { toast } from "react-toastify";
import { getCart, updateCartItem, deleteCartItem } from "../../services/apiCart";

const { Title, Text } = Typography;

interface CartItem {
  id: number;
  quantity: number;
  finalPrice: number;
  total: number;
  product: {
    id: number | string;
    name: string;
    image: string;
    price: number;
    sale: number;
  };
}

export default function Cart() {
  const navigate = useNavigate();
  const [items, setItems] = useState<CartItem[]>([]);
  const [loading, setLoading] = useState(true);

  const fetchCartItems = async () => {
    try {
      const res = await getCart();
      if (res?.status === "success" && res?.data?.cartItems) {
        setItems(res.data.cartItems);
      }
    } catch (error) {
      console.error("Error fetching cart:", error);
      toast.error("Không thể lấy dữ liệu giỏ hàng.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchCartItems();
  }, []);

  const handleUpdateQty = async (itemId: number, newQty: number) => {
    if (newQty < 1) return;
    try {
      await updateCartItem(itemId, newQty);
      fetchCartItems();
    } catch (error) {
      console.error(error);
      toast.error("Cập nhật số lượng thất bại.");
    }
  };

  const handleDeleteItem = async (itemId: number) => {
    try {
      await deleteCartItem(itemId);
      toast.success("Đã xóa sản phẩm khỏi giỏ hàng.");
      fetchCartItems();
    } catch (error) {
      console.error(error);
      toast.error("Xóa sản phẩm thất bại.");
    }
  };

  const calculateSubtotal = () => {
    return items.reduce((sum, item) => sum + item.total, 0);
  };

  const columns = [
    {
      title: "Sản phẩm",
      dataIndex: "product",
      key: "product",
      render: (product: any) => (
        <Space size="middle">
          <img
            src={product.image}
            alt={product.name}
            style={{ width: 60, height: 60, objectFit: "contain", borderRadius: 8 }}
          />
          <div>
            <Link to={`/product/${product.slug || ""}`} style={{ fontWeight: 600, color: "var(--color-text)" }}>
              {product.name}
            </Link>
            {product.sale > 0 && (
              <div style={{ fontSize: "12px", color: "var(--color-secondary)" }}>Giảm {product.sale}%</div>
            )}
          </div>
        </Space>
      ),
    },
    {
      title: "Đơn giá",
      dataIndex: "finalPrice",
      key: "finalPrice",
      render: (price: number) => <Text>{price.toLocaleString("vi-VN")} VND</Text>,
    },
    {
      title: "Số lượng",
      dataIndex: "quantity",
      key: "quantity",
      render: (quantity: number, record: CartItem) => (
        <div style={{ display: "flex", alignItems: "center", border: "1px solid var(--color-border)", borderRadius: "4px", width: "100px", overflow: "hidden" }}>
          <Button
            size="small"
            icon={<MinusOutlined style={{ fontSize: 10 }} />}
            onClick={() => handleUpdateQty(record.id, quantity - 1)}
            style={{ border: "none", borderRadius: 0, background: "#f5f5f5" }}
          />
          <InputNumber
            min={1}
            value={quantity}
            onChange={(val) => handleUpdateQty(record.id, val || 1)}
            style={{ border: "none", width: 44, textAlign: "center", padding: 0 }}
            controls={false}
          />
          <Button
            size="small"
            icon={<PlusOutlined style={{ fontSize: 10 }} />}
            onClick={() => handleUpdateQty(record.id, quantity + 1)}
            style={{ border: "none", borderRadius: 0, background: "#f5f5f5" }}
          />
        </div>
      ),
    },
    {
      title: "Tổng tiền",
      dataIndex: "total",
      key: "total",
      render: (total: number) => <Text style={{ fontWeight: 600 }}>{total.toLocaleString("vi-VN")} VND</Text>,
    },
    {
      title: "Thao tác",
      key: "action",
      render: (_: any, record: CartItem) => (
        <Button
          type="text"
          danger
          icon={<DeleteOutlined />}
          onClick={() => handleDeleteItem(record.id)}
        />
      ),
    },
  ];

  if (loading) {
    return (
      <div style={{ textAlign: "center", padding: "100px 0" }}>
        <Spin size="large" />
      </div>
    );
  }

  if (items.length === 0) {
    return (
      <div style={{ maxWidth: 800, margin: "50px auto", padding: "0 20px" }}>
        <Card style={{ borderRadius: 16, boxShadow: "var(--shadow-md)", border: "none" }}>
          <Empty
            image={Empty.PRESENTED_IMAGE_SIMPLE}
            description="Giỏ hàng của bạn đang trống"
          />
          <div style={{ marginTop: 24 }}>
            <Link to="/">
              <Button type="primary" icon={<ArrowLeftOutlined />} style={{ background: "var(--color-primary)", borderColor: "var(--color-primary)" }}>
                Tiếp tục mua sắm
              </Button>
            </Link>
          </div>
        </Card>
      </div>
    );
  }

  return (
    <div style={{ maxWidth: 1200, margin: "20px auto", padding: "0 20px", textAlign: "left" }}>
      <Title level={2} style={{ marginBottom: 24 }}>
        <ShoppingCartOutlined style={{ marginRight: 10, color: "var(--color-primary)" }} />
        Giỏ Hàng Của Bạn
      </Title>

      <Row gutter={[24, 24]}>
        {/* TABLE */}
        <Col xs={24} lg={17}>
          <Card style={{ borderRadius: 12, boxShadow: "var(--shadow-sm)", border: "none" }} bodyStyle={{ padding: "0 10px" }}>
            <Table
              dataSource={items}
              columns={columns}
              rowKey="id"
              pagination={false}
              scroll={{ x: 600 }}
            />
          </Card>
        </Col>

        {/* SUMMARY */}
        <Col xs={24} lg={7}>
          <Card
            title={<strong style={{ fontSize: "18px" }}>Tóm tắt đơn hàng</strong>}
            style={{ borderRadius: 12, boxShadow: "var(--shadow-sm)", border: "none" }}
          >
            <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 16 }}>
              <Text type="secondary">Tạm tính:</Text>
              <Text style={{ fontWeight: 600 }}>{calculateSubtotal().toLocaleString("vi-VN")} VND</Text>
            </div>
            <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 16 }}>
              <Text type="secondary">Phí vận chuyển:</Text>
              <Text style={{ color: "var(--color-primary)", fontWeight: "500" }}>Miễn phí</Text>
            </div>
            <div style={{ borderTop: "1px solid var(--color-border)", padding: "16px 0", display: "flex", justifyContent: "space-between" }}>
              <Text style={{ fontSize: "16px", fontWeight: "bold" }}>Tổng cộng:</Text>
              <Text style={{ fontSize: "20px", fontWeight: "bold", color: "var(--color-secondary)" }}>
                {calculateSubtotal().toLocaleString("vi-VN")} VND
              </Text>
            </div>

            <Button
              type="primary"
              size="large"
              icon={<CreditCardOutlined />}
              onClick={() => navigate("/checkout")}
              style={{
                width: "100%",
                background: "var(--color-primary)",
                borderColor: "var(--color-primary)",
                height: 48,
                borderRadius: 8,
                fontWeight: "bold",
                marginTop: 10,
              }}
            >
              Tiến hành thanh toán
            </Button>
          </Card>
        </Col>
      </Row>
    </div>
  );
}
