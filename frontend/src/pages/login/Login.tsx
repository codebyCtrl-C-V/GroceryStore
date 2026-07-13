import { Form, Input, Button, Card, Typography } from "antd";
import { LockOutlined, MailOutlined } from "@ant-design/icons";
import { Link } from "react-router-dom";
import { useState } from "react";
import { toast } from "react-toastify";
import { loginUser } from "../../services/apiUser";
import useAuth from "../../hooks/useAuth";

const { Title, Paragraph } = Typography;

export default function Login() {
  const { login } = useAuth();
  const [loading, setLoading] = useState(false);

  const onFinish = async (values: any) => {
    setLoading(true);
    try {
      const res = await loginUser({
        email: values.email,
        password: values.password,
      });

      if (res?.status === "success" && res?.data) {
        toast.success("Đăng nhập thành công!");
        await login(res.data.accessToken, res.data.refreshToken, true);
      } else {
        toast.error(res?.message || "Đăng nhập thất bại");
      }
    } catch (error: any) {
      console.error("Login error:", error);
      toast.error(
        error.response?.data?.message || "Sai tài khoản hoặc mật khẩu!"
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <div
      style={{
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        minHeight: "75vh",
        padding: "20px 0",
      }}
    >
      <Card
        style={{
          width: 420,
          borderRadius: "12px",
          boxShadow: "var(--shadow-md)",
          border: "none",
        }}
      >
        <div style={{ textAlign: "center", marginBottom: 24 }}>
          <Title level={2} style={{ color: "var(--color-primary)", margin: 0 }}>
            Đăng Nhập
          </Title>
          <Paragraph type="secondary">Chào mừng bạn trở lại với D-Food!</Paragraph>
        </div>

        <Form
          name="login_form"
          initialValues={{ remember: true }}
          onFinish={onFinish}
          layout="vertical"
          size="large"
        >
          <Form.Item
            name="email"
            rules={[
              { required: true, message: "Vui lòng nhập Email!" },
              { type: "email", message: "Email không hợp lệ!" },
            ]}
          >
            <Input
              prefix={<MailOutlined style={{ color: "var(--color-text-light)" }} />}
              placeholder="Email"
            />
          </Form.Item>

          <Form.Item
            name="password"
            rules={[{ required: true, message: "Vui lòng nhập Mật khẩu!" }]}
          >
            <Input.Password
              prefix={<LockOutlined style={{ color: "var(--color-text-light)" }} />}
              placeholder="Mật khẩu"
            />
          </Form.Item>

          <Form.Item>
            <Button
              type="primary"
              htmlType="submit"
              loading={loading}
              style={{
                width: "100%",
                background: "var(--color-primary)",
                borderColor: "var(--color-primary)",
                borderRadius: "6px",
                height: "45px",
                fontWeight: "500",
              }}
            >
              Đăng Nhập
            </Button>
          </Form.Item>
        </Form>

        <div style={{ textAlign: "center", marginTop: 16 }}>
          Chưa có tài khoản?{" "}
          <Link to="/register" style={{ color: "var(--color-primary)", fontWeight: "500" }}>
            Đăng ký ngay
          </Link>
        </div>
      </Card>
    </div>
  );
}
