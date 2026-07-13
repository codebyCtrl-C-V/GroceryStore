import { Card, Typography, Row, Col, Button, Space, Tag } from "antd";
import { MailOutlined } from "@ant-design/icons";
import { toast } from "react-toastify";

const { Title, Paragraph } = Typography;

export default function Recruitment() {
  const jobs = [
    {
      title: "Thu Ngân Cửa Hàng",
      salary: "6M - 8M VND",
      type: "Full-time / Part-time",
      desc: "Quản lý doanh thu tại quầy thanh toán, in hóa đơn và hỗ trợ thanh toán cho khách hàng.",
      reqs: "Cẩn thận, trung thực, giao tiếp tốt, ưu tiên các bạn có kinh nghiệm thu ngân.",
      color: "blue",
    },
    {
      title: "Quản Lý Cửa Hàng",
      salary: "12M - 15M VND",
      type: "Full-time",
      desc: "Chịu trách nhiệm vận hành cửa hàng, quản lý nhân viên, doanh số và hàng hóa tồn kho.",
      reqs: "Tối thiểu 1 năm kinh nghiệm quản lý bán lẻ, có kỹ năng lãnh đạo và xử lý tình huống tốt.",
      color: "red",
    },
    {
      title: "Nhân Viên Kho",
      salary: "7M - 9M VND",
      type: "Full-time",
      desc: "Kiểm đếm hàng hóa xuất nhập kho, sắp xếp sản phẩm lên kệ và bảo quản thực phẩm đúng quy trình.",
      reqs: "Sức khỏe tốt, chăm chỉ, nhanh nhẹn, có tinh thần trách nhiệm trong công việc.",
      color: "orange",
    },
    {
      title: "Nhân Viên Giao Hàng",
      salary: "8M - 12M VND",
      type: "Linh hoạt",
      desc: "Giao thực phẩm tươi sạch đến địa chỉ của khách hàng và thu tiền COD (nếu có).",
      reqs: "Có phương tiện cá nhân (xe máy), thông thạo đường phố Hà Nội, thân thiện với khách hàng.",
      color: "green",
    },
  ];

  const handleApply = (jobTitle: string) => {
    toast.info(`Ứng tuyển vị trí "${jobTitle}". Vui lòng gửi CV về hòm thư trandiengtc@gmail.com!`);
  };

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
            Tuyển Dụng
          </Title>
          <Paragraph type="secondary">
            Gia nhập đại gia đình D-Food - Cùng kiến tạo không gian thực phẩm chất lượng cho mọi nhà
          </Paragraph>
        </div>

        <Row gutter={[16, 16]}>
          {jobs.map((job, index) => (
            <Col xs={24} md={12} key={index}>
              <Card
                title={
                  <div style={{ display: "flex", justifyContent: "between", alignItems: "center", flexWrap: "wrap", gap: "8px" }}>
                    <span style={{ fontSize: "17px", fontWeight: "bold" }}>{job.title}</span>
                    <Tag color={job.color}>{job.type}</Tag>
                  </div>
                }
                extra={<span style={{ color: "var(--color-secondary)", fontWeight: "bold" }}>{job.salary}</span>}
                style={{
                  height: "100%",
                  borderRadius: 12,
                  boxShadow: "var(--shadow-sm)",
                  border: "1px solid var(--color-border)",
                }}
              >
                <Paragraph style={{ margin: "0 0 10px" }}>
                  <strong>Mô tả công việc:</strong> {job.desc}
                </Paragraph>
                <Paragraph style={{ margin: "0 0 20px" }}>
                  <strong>Yêu cầu:</strong> {job.reqs}
                </Paragraph>
                <Button
                  type="primary"
                  onClick={() => handleApply(job.title)}
                  style={{
                    background: "var(--color-primary)",
                    borderColor: "var(--color-primary)",
                    borderRadius: "6px",
                  }}
                >
                  Ứng tuyển ngay
                </Button>
              </Card>
            </Col>
          ))}
        </Row>

        <div
          style={{
            textAlign: "center",
            marginTop: 40,
            padding: "20px",
            backgroundColor: "var(--color-primary-light)",
            borderRadius: "12px",
          }}
        >
          <Title level={4} style={{ color: "var(--color-primary-bold)", margin: "0 0 10px" }}>
            Cách thức ứng tuyển
          </Title>
          <Paragraph style={{ fontSize: "16px", margin: 0 }}>
            <Space>
              <MailOutlined />
              <span>Vui lòng gửi CV/Hồ sơ ứng tuyển của bạn về hòm thư:</span>
              <a href="mailto:trandiengtc@gmail.com" style={{ fontWeight: "bold", color: "var(--color-primary-bold)" }}>
                trandiengtc@gmail.com
              </a>
            </Space>
          </Paragraph>
        </div>
      </Card>
    </div>
  );
}
