import { Card, Typography, Row, Col, Space } from "antd";
import {
  ShoppingCartOutlined,
  CreditCardOutlined,
  CarOutlined,
  ReloadOutlined,
} from "@ant-design/icons";

const { Title, Paragraph } = Typography;

export default function Policy() {
  const policies = [
    {
      title: "Chính Sách Đặt Hàng",
      icon: <ShoppingCartOutlined style={{ fontSize: 24, color: "#1677ff" }} />,
      color: "#e6f4ff",
      items: [
        "Mua sắm trực tiếp tại hệ thống cửa hàng.",
        "Đặt hàng nhanh chóng qua hệ thống website hoặc hotline hỗ trợ.",
        "Hủy đơn hàng miễn phí trong vòng 1 giờ kể từ khi đặt.",
      ],
    },
    {
      title: "Chính Sách Thanh Toán",
      icon: <CreditCardOutlined style={{ fontSize: 24, color: "#ff4d4f" }} />,
      color: "#fff1f0",
      items: [
        "Thanh toán trực tiếp bằng tiền mặt khi nhận hàng (COD).",
        "Thanh toán trực tuyến bảo mật thông qua VNPay.",
        "Thông tin giao dịch được mã hóa và bảo mật hoàn toàn.",
      ],
    },
    {
      title: "Chính Sách Giao Hàng",
      icon: <CarOutlined style={{ fontSize: 24, color: "#faad14" }} />,
      color: "#fffbe6",
      items: [
        "Giao hàng nhanh trong vòng 24 giờ cho khu vực nội thành.",
        "Miễn phí vận chuyển cho tất cả đơn hàng có giá trị trên 500K.",
        "Được đồng kiểm, kiểm tra chất lượng sản phẩm trước khi thanh toán.",
      ],
    },
    {
      title: "Chính Sách Đổi Trả",
      icon: <ReloadOutlined style={{ fontSize: 24, color: "#52c41a" }} />,
      color: "#f6ffed",
      items: [
        "Hỗ trợ đổi trả sản phẩm trong vòng 48 giờ kể từ khi nhận.",
        "Yêu cầu sản phẩm còn nguyên bao bì và không bị hư hỏng do bảo quản.",
        "Hoàn tiền 100% nếu phát hiện sản phẩm lỗi, hỏng từ nhà cung cấp.",
      ],
    },
  ];

  return (
    <div style={{ maxWidth: 1000, margin: "30px auto", padding: "0 20px" }}>
      <Card
        style={{
          borderRadius: 16,
          boxShadow: "var(--shadow-md)",
          border: "none",
          textAlign: "left",
        }}
      >
        <div style={{ textAlign: "center", marginBottom: 30 }}>
          <Title level={1} style={{ color: "var(--color-primary)", margin: "10px 0" }}>
            Chính Sách Mua Hàng
          </Title>
          <Paragraph type="secondary">
            Tham khảo các điều khoản quy định khi mua sắm tại D-Food để đảm bảo quyền lợi tốt nhất
          </Paragraph>
        </div>

        <Row gutter={[16, 16]}>
          {policies.map((policy, idx) => (
            <Col xs={24} md={12} key={idx}>
              <Card
                style={{
                  height: "100%",
                  borderRadius: 12,
                  boxShadow: "var(--shadow-sm)",
                  border: "1px solid var(--color-border)",
                }}
                bodyStyle={{ padding: "20px" }}
              >
                <div style={{ display: "flex", alignItems: "center", marginBottom: 16 }}>
                  <div
                    style={{
                      backgroundColor: policy.color,
                      padding: "10px",
                      borderRadius: "8px",
                      display: "flex",
                      marginRight: "12px",
                    }}
                  >
                    {policy.icon}
                  </div>
                  <Title level={4} style={{ margin: 0, fontSize: "18px" }}>
                    {policy.title}
                  </Title>
                </div>
                <ul style={{ paddingLeft: 20, margin: 0, lineHeight: "1.8", color: "var(--color-text-light)" }}>
                  {policy.items.map((item, itemIdx) => (
                    <li key={itemIdx}>{item}</li>
                  ))}
                </ul>
              </Card>
            </Col>
          ))}
        </Row>

        <div style={{ textAlign: "center", marginTop: 30, fontSize: "16px" }}>
          <Space>
            <span>Mọi thắc mắc và đóng góp ý kiến vui lòng liên hệ:</span>
            <a href="mailto:trandiengtc@gmail.com" style={{ color: "var(--color-primary)", fontWeight: "500" }}>
              trandiengtc@gmail.com
            </a>
          </Space>
        </div>
      </Card>
    </div>
  );
}
