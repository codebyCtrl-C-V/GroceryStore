import { Card, Typography, List } from "antd";
import { CheckCircleOutlined } from "@ant-design/icons";

const { Title, Paragraph } = Typography;

export default function Introduce() {
  const points = [
    {
      title: "Nguồn Gốc Rõ Ràng",
      description: "Nhập khẩu thực phẩm từ các trang trại và nhà cung cấp uy tín hàng đầu trong và ngoài nước.",
    },
    {
      title: "Sản Phẩm Đa Dạng",
      description: "Rau củ quả hữu cơ sạch, thịt cá hải sản tươi sống chất lượng cao, thực phẩm chế biến tiện lợi, đặc sản vùng miền phong phú.",
    },
    {
      title: "Cam Kết Chất Lượng",
      description: "Đảm bảo quy trình kiểm định vệ sinh an toàn thực phẩm nghiêm ngặt nhất, bảo vệ tốt sức khỏe gia đình bạn.",
    },
    {
      title: "Dịch Vụ Tiện Lợi",
      description: "Đặt hàng nhanh chóng qua website, giao hàng tận nhà trong ngày, thanh toán đa dạng và hỗ trợ tận tâm.",
    },
  ];

  return (
    <div style={{ maxWidth: 800, margin: "30px auto", padding: "0 20px" }}>
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
            Giới Thiệu
          </Title>
          <Paragraph type="secondary">
            Cung cấp nguồn thực phẩm xanh - sạch - tươi cho gia đình Việt
          </Paragraph>
        </div>

        <Title level={3} style={{ color: "var(--color-primary-bold)" }}>
          Chào mừng bạn đến với D-Food! 🌿🥦🥩
        </Title>
        <Paragraph style={{ fontSize: "16px", lineHeight: "1.6" }}>
          Chúng tôi tự hào là hệ thống cung cấp thực phẩm tươi sạch, an toàn vệ sinh và chất lượng hàng đầu. Với tôn chỉ mang đến những bữa ăn ngon lành, tràn đầy năng lượng cho mọi gia đình, D-Food không ngừng nỗ lực chọn lọc những sản phẩm tinh túy nhất từ những vùng nguyên liệu trù phú.
        </Paragraph>

        <List
          header={<div style={{ fontWeight: "bold", fontSize: "18px", color: "var(--color-text)" }}>Những giá trị cốt lõi từ D-Food:</div>}
          dataSource={points}
          renderItem={(item) => (
            <List.Item>
              <List.Item.Meta
                avatar={<CheckCircleOutlined style={{ color: "var(--color-primary)", fontSize: "20px", marginTop: "4px" }} />}
                title={<strong style={{ fontSize: "16px" }}>{item.title}</strong>}
                description={<span style={{ fontSize: "15px" }}>{item.description}</span>}
              />
            </List.Item>
          )}
          style={{ marginTop: 20 }}
        />
      </Card>
    </div>
  );
}
