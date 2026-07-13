import { Card, Typography, Row, Col, Form, Input, Button, Radio, Space, Spin, Empty, List } from "antd";
import { HomeOutlined, PhoneOutlined, UserOutlined, ArrowLeftOutlined, CheckCircleOutlined } from "@ant-design/icons";
import { useEffect, useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { toast } from "react-toastify";
import { getCheckout, submitOrder, createPaymentUrl } from "../../services/apiOrder";
import useAuth from "../../hooks/useAuth";

const { Title, Text, Paragraph } = Typography;

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

export default function Checkout() {
  const navigate = useNavigate();
  const { userInfor } = useAuth();
  const [items, setItems] = useState<CartItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [form] = Form.useForm();

  const fetchCheckoutData = async () => {
    try {
      const res = await getCheckout();
      if (res?.status === "success" && res?.data?.cartItems) {
        setItems(res.data.cartItems);
      }
    } catch (error) {
      console.error("Error fetching checkout details:", error);
      toast.error("Không thể lấy thông tin thanh toán.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchCheckoutData();
  }, []);

  useEffect(() => {
    if (userInfor) {
      form.setFieldsValue({
        name: userInfor.name || "",
        phone: userInfor.phone || "",
        address: userInfor.address || "",
      });
    }
  }, [userInfor]);

  const calculateTotal = () => {
    return items.reduce((sum, item) => sum + item.total, 0);
  };

  const onFinish = async (values: any) => {
    if (items.length === 0) {
      toast.error("Giỏ hàng của bạn đang trống!");
      return;
    }

    setSubmitting(true);
    try {
      const totalAmount = calculateTotal();

      if (values.paymentMethod === "cod") {
        const res = await submitOrder({
          name: values.name,
          phone: values.phone,
          address: values.address,
          paymentMethod: "cod",
        });

        if (res?.status === "success") {
          toast.success("Đặt hàng thành công!");
          navigate("/orders");
        } else {
          toast.error(res?.message || "Đặt hàng thất bại");
        }
      } else {
        // VNPAY Payment
        const res = await createPaymentUrl(
          totalAmount,
          `Thanh toan don hang D-Food - ${values.name}`,
          values.name,
          values.phone,
          values.address
        );

        if (res?.paymentUrl) {
          toast.info("Đang chuyển hướng sang cổng thanh toán VNPAY...");
          window.location.href = res.paymentUrl;
        } else {
          toast.error("Không thể tạo liên kết thanh toán VNPAY.");
        }
      }
    } catch (error: any) {
      console.error("Checkout error:", error);
      toast.error(error.response?.data?.message || "Có lỗi xảy ra khi thanh toán!");
    } finally {
      setSubmitting(false);
    }
  };

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
          <Empty description="Không có sản phẩm nào để thanh toán" />
          <div style={{ marginTop: 24 }}>
            <Link to="/">
              <Button type="primary" icon={<ArrowLeftOutlined />} style={{ background: "var(--color-primary)", borderColor: "var(--color-primary)" }}>
                Quay lại mua sắm
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
        Thanh Toán Đơn Hàng
      </Title>

      <Form
        form={form}
        onFinish={onFinish}
        layout="vertical"
        size="large"
        initialValues={{ paymentMethod: "cod" }}
      >
        <Row gutter={[24, 24]}>
          {/* SHIPPING & PAYMENT */}
          <Col xs={24} lg={15}>
            <Card
              title={<strong style={{ fontSize: "18px" }}>Thông tin nhận hàng</strong>}
              style={{ borderRadius: 12, boxShadow: "var(--shadow-sm)", border: "none", marginBottom: 24 }}
            >
              <Form.Item
                name="name"
                label="Họ và tên người nhận"
                rules={[{ required: true, message: "Vui lòng nhập Họ tên người nhận!" }]}
              >
                <Input prefix={<UserOutlined />} placeholder="Họ và tên" />
              </Form.Item>

              <Form.Item
                name="phone"
                label="Số điện thoại liên hệ"
                rules={[
                  { required: true, message: "Vui lòng nhập Số điện thoại nhận hàng!" },
                  { pattern: /^[0-9]{10,11}$/, message: "Số điện thoại không hợp lệ!" },
                ]}
              >
                <Input prefix={<PhoneOutlined />} placeholder="Số điện thoại" />
              </Form.Item>

              <Form.Item
                name="address"
                label="Địa chỉ giao hàng chi tiết"
                rules={[{ required: true, message: "Vui lòng nhập Địa chỉ giao hàng!" }]}
              >
                <Input prefix={<HomeOutlined />} placeholder="Số nhà, ngõ/ngách, tên đường, quận/huyện..." />
              </Form.Item>
            </Card>

            <Card
              title={<strong style={{ fontSize: "18px" }}>Phương thức thanh toán</strong>}
              style={{ borderRadius: 12, boxShadow: "var(--shadow-sm)", border: "none" }}
            >
              <Form.Item name="paymentMethod" style={{ margin: 0 }}>
                <Radio.Group style={{ width: "100%" }}>
                  <Space direction="vertical" style={{ width: "100%" }} size="middle">
                    <Radio value="cod" style={{ width: "100%" }}>
                      <Space>
                        <strong style={{ fontSize: "15px" }}>Thanh toán khi nhận hàng (COD)</strong>
                        <Paragraph type="secondary" style={{ margin: 0, fontSize: "13px" }}>
                          Nhận hàng và thanh toán trực tiếp cho nhân viên giao hàng
                        </Paragraph>
                      </Space>
                    </Radio>
                    <Radio value="online" style={{ width: "100%" }}>
                      <Space>
                        <strong style={{ fontSize: "15px" }}>Thanh toán trực tuyến (VNPAY Gateway)</strong>
                        <Paragraph type="secondary" style={{ margin: 0, fontSize: "13px" }}>
                          Sử dụng tài khoản ngân hàng nội địa hoặc quét mã QR
                        </Paragraph>
                      </Space>
                    </Radio>
                  </Space>
                </Radio.Group>
              </Form.Item>
            </Card>
          </Col>

          {/* ORDER REVIEW & SUMMARY */}
          <Col xs={24} lg={9}>
            <Card
              title={<strong style={{ fontSize: "18px" }}>Chi tiết đơn hàng</strong>}
              style={{ borderRadius: 12, boxShadow: "var(--shadow-sm)", border: "none" }}
            >
              <List
                itemLayout="horizontal"
                dataSource={items}
                renderItem={(item) => (
                  <List.Item style={{ padding: "12px 0" }}>
                    <List.Item.Meta
                      avatar={
                        <img
                          src={item.product.image}
                          alt={item.product.name}
                          style={{ width: 45, height: 45, objectFit: "contain", borderRadius: 4 }}
                        />
                      }
                      title={
                        <div style={{ display: "flex", justifyContent: "space-between", flexWrap: "nowrap", gap: "8px" }}>
                          <span style={{ fontSize: "14px", fontWeight: "600", textOverflow: "ellipsis", overflow: "hidden", whiteSpace: "nowrap", maxWidth: 160 }}>
                            {item.product.name}
                          </span>
                          <span style={{ fontSize: "14px", fontWeight: "600" }}>
                            {item.total.toLocaleString("vi-VN")} VND
                          </span>
                        </div>
                      }
                      description={
                        <Text type="secondary" style={{ fontSize: "13px" }}>
                          Đơn giá: {item.finalPrice.toLocaleString("vi-VN")} VND x {item.quantity}
                        </Text>
                      }
                    />
                  </List.Item>
                )}
                style={{ maxHeight: 300, overflowY: "auto", marginBottom: 20 }}
              />

              <div style={{ borderTop: "1px solid var(--color-border)", paddingTop: 16 }}>
                <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 12 }}>
                  <Text type="secondary">Tạm tính:</Text>
                  <Text style={{ fontWeight: 600 }}>{calculateTotal().toLocaleString("vi-VN")} VND</Text>
                </div>
                <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 12 }}>
                  <Text type="secondary">Vận chuyển:</Text>
                  <Text style={{ color: "var(--color-primary)", fontWeight: "500" }}>Miễn phí</Text>
                </div>
                <div style={{ borderTop: "1px solid var(--color-border)", padding: "16px 0 0 0", display: "flex", justifyContent: "space-between" }}>
                  <Text style={{ fontSize: "16px", fontWeight: "bold" }}>Tổng số tiền:</Text>
                  <Text style={{ fontSize: "22px", fontWeight: "bold", color: "var(--color-secondary)" }}>
                    {calculateTotal().toLocaleString("vi-VN")} VND
                  </Text>
                </div>
              </div>

              <Button
                type="primary"
                htmlType="submit"
                size="large"
                loading={submitting}
                icon={<CheckCircleOutlined />}
                style={{
                  width: "100%",
                  background: "var(--color-primary)",
                  borderColor: "var(--color-primary)",
                  height: 50,
                  borderRadius: 8,
                  fontWeight: "bold",
                  marginTop: 24,
                }}
              >
                Xác nhận đặt hàng
              </Button>
            </Card>
          </Col>
        </Row>
      </Form>
    </div>
  );
}
