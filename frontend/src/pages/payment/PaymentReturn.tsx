import { Card, Typography, Spin, Button, Space } from "antd";
import { CheckCircleOutlined, CloseCircleOutlined, ShoppingCartOutlined, UnorderedListOutlined } from "@ant-design/icons";
import { useEffect, useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { handleVnpayReturn } from "../../services/apiOrder";

const { Title, Paragraph, Text } = Typography;

interface OrderInfo {
  orderId: number | string;
  txnRef: string;
  amount: number;
  bankCode: string;
  transactionNo: string;
  payDate: string;
}

export default function PaymentReturn() {
  const location = useLocation();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [success, setSuccess] = useState(false);
  const [message, setMessage] = useState("");
  const [orderInfo, setOrderInfo] = useState<OrderInfo | null>(null);
  const [countdown, setCountdown] = useState(5);

  useEffect(() => {
    const verifyPayment = async () => {
      try {
        const res = await handleVnpayReturn(location.search);
        if (res?.status === "success" && res?.data?.code === "00") {
          setSuccess(true);
          setMessage(res.data.message || "Thanh toán thành công!");
          setOrderInfo(res.data.orderInfo);
        } else {
          setSuccess(false);
          setMessage(res?.data?.message || res?.message || "Thanh toán thất bại hoặc đã bị hủy.");
        }
      } catch (error) {
        console.error("Payment verification error:", error);
        setSuccess(false);
        setMessage("Có lỗi xảy ra khi xác thực kết quả thanh toán.");
      } finally {
        setLoading(false);
      }
    };

    verifyPayment();
  }, [location.search]);

  // Countdown timer for automatic redirect
  useEffect(() => {
    if (!loading && success) {
      const timer = setInterval(() => {
        setCountdown((prev) => {
          if (prev <= 1) {
            clearInterval(timer);
            navigate("/orders");
            return 0;
          }
          return prev - 1;
        });
      }, 1000);
      return () => clearInterval(timer);
    }
  }, [loading, success, navigate]);

  if (loading) {
    return (
      <div style={{ display: "flex", justifyContent: "center", alignItems: "center", minHeight: "70vh", flexDirection: "column", gap: "16px" }}>
        <Spin size="large" />
        <Text style={{ fontSize: "16px" }}>Đang xử lý kết quả giao dịch. Vui lòng không đóng trình duyệt...</Text>
      </div>
    );
  }

  return (
    <div style={{ display: "flex", justifyContent: "center", alignItems: "center", minHeight: "75vh", padding: "20px 0" }}>
      <Card
        style={{
          width: 550,
          borderRadius: "16px",
          boxShadow: "var(--shadow-md)",
          border: "none",
          textAlign: "center",
        }}
        bodyStyle={{ padding: "40px 30px" }}
      >
        {success ? (
          <div>
            <CheckCircleOutlined style={{ fontSize: "72px", color: "var(--color-primary)", marginBottom: "20px" }} />
            <Title level={2} style={{ color: "var(--color-primary)", margin: "0 0 10px 0" }}>
              Thanh Toán Thành Công!
            </Title>
            <Paragraph type="secondary" style={{ fontSize: "15px", marginBottom: 30 }}>
              {message}
            </Paragraph>

            {orderInfo && (
              <Card
                style={{
                  background: "#f8fafc",
                  borderRadius: "12px",
                  border: "1px solid var(--color-border)",
                  textAlign: "left",
                  marginBottom: 30,
                }}
                bodyStyle={{ padding: "20px" }}
              >
                <div style={{ display: "flex", flexDirection: "column", gap: "10px", fontSize: "14px" }}>
                  <div>
                    <Text type="secondary">Mã đơn hàng D-Food: </Text>
                    <Text strong>#{orderInfo.orderId}</Text>
                  </div>
                  <div>
                    <Text type="secondary">Mã giao dịch VNPAY: </Text>
                    <Text strong>{orderInfo.transactionNo}</Text>
                  </div>
                  <div>
                    <Text type="secondary">Ngân hàng thanh toán: </Text>
                    <Text strong>{orderInfo.bankCode}</Text>
                  </div>
                  <div>
                    <Text type="secondary">Số tiền giao dịch: </Text>
                    <Text strong style={{ color: "var(--color-secondary)", fontSize: "16px" }}>
                      {orderInfo.amount.toLocaleString("vi-VN")} VND
                    </Text>
                  </div>
                </div>
              </Card>
            )}

            <Paragraph style={{ marginBottom: 24, fontSize: "14px" }}>
              Tự động chuyển về trang Đơn hàng sau <Text strong style={{ color: "var(--color-primary)" }}>{countdown}</Text> giây...
            </Paragraph>

            <Button
              type="primary"
              size="large"
              icon={<UnorderedListOutlined />}
              onClick={() => navigate("/orders")}
              style={{
                background: "var(--color-primary)",
                borderColor: "var(--color-primary)",
                height: 45,
                borderRadius: 8,
                fontWeight: "bold",
                width: "100%",
              }}
            >
              Xem danh sách đơn hàng
            </Button>
          </div>
        ) : (
          <div>
            <CloseCircleOutlined style={{ fontSize: "72px", color: "#ff4d4f", marginBottom: "20px" }} />
            <Title level={2} style={{ color: "#ff4d4f", margin: "0 0 10px 0" }}>
              Thanh Toán Thất Bại
            </Title>
            <Paragraph type="secondary" style={{ fontSize: "15px", marginBottom: 30 }}>
              {message}
            </Paragraph>

            <Space direction="vertical" style={{ width: "100%" }} size="middle">
              <Button
                type="primary"
                size="large"
                icon={<ShoppingCartOutlined />}
                onClick={() => navigate("/cart")}
                style={{
                  background: "var(--color-primary)",
                  borderColor: "var(--color-primary)",
                  height: 45,
                  borderRadius: 8,
                  fontWeight: "bold",
                  width: "100%",
                }}
              >
                Quay lại giỏ hàng
              </Button>
              <Button size="large" onClick={() => navigate("/")} style={{ width: "100%", borderRadius: 8 }}>
                Về trang chủ
              </Button>
            </Space>
          </div>
        )}
      </Card>
    </div>
  );
}
