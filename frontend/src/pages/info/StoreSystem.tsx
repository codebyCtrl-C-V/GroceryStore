import { Card, Typography, Row, Col, Space } from "antd";
import { PhoneOutlined, EnvironmentOutlined, ClockCircleOutlined } from "@ant-design/icons";

const { Title, Paragraph } = Typography;

export default function StoreSystem() {
  const stores = [
    {
      name: "D-Food Cơ sở 1 - Tứ Hiệp",
      address: "Số xx, tòa nhà IEC, Tứ Hiệp, Thanh Trì, Hà Nội",
      hotline: "0944 538 620",
      hours: "07:30 - 21:30 hàng ngày",
    },
    {
      name: "D-Food Cơ sở 2 - Lê Thanh Nghị",
      address: "Số xx, đường Lê Thanh Nghị, Hai Bà Trưng, Hà Nội",
      hotline: "0123 456 789",
      hours: "07:30 - 22:00 hàng ngày",
    },
  ];

  return (
    <div style={{ maxWidth: 900, margin: "30px auto", padding: "0 20px" }}>
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
            Hệ Thống Cửa Hàng
          </Title>
          <Paragraph type="secondary">
            Tìm địa chỉ cửa hàng D-Food gần bạn nhất để được phục vụ tốt nhất
          </Paragraph>
        </div>

        <Row gutter={[16, 16]}>
          {stores.map((store, idx) => (
            <Col xs={24} md={12} key={idx}>
              <Card
                style={{
                  height: "100%",
                  borderRadius: 12,
                  boxShadow: "var(--shadow-sm)",
                  border: "1px solid var(--color-border)",
                }}
                title={
                  <span style={{ fontSize: "16px", fontWeight: "bold", color: "var(--color-primary-bold)" }}>
                    {store.name}
                  </span>
                }
              >
                <Space direction="vertical" size="middle" style={{ width: "100%" }}>
                  <div>
                    <EnvironmentOutlined style={{ marginRight: 8, color: "var(--color-primary)" }} />
                    <strong>Địa chỉ:</strong>
                    <div style={{ paddingLeft: 22, color: "var(--color-text-light)" }}>{store.address}</div>
                  </div>

                  <div>
                    <PhoneOutlined style={{ marginRight: 8, color: "var(--color-primary)" }} />
                    <strong>Hotline:</strong>
                    <div style={{ paddingLeft: 22, color: "var(--color-text-light)" }}>{store.hotline}</div>
                  </div>

                  <div>
                    <ClockCircleOutlined style={{ marginRight: 8, color: "var(--color-primary)" }} />
                    <strong>Giờ mở cửa:</strong>
                    <div style={{ paddingLeft: 22, color: "var(--color-text-light)" }}>{store.hours}</div>
                  </div>
                </Space>
              </Card>
            </Col>
          ))}
        </Row>
      </Card>
    </div>
  );
}
