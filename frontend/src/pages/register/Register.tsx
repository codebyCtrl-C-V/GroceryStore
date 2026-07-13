import { Form, Input, Button, Card, Typography } from "antd";
import { LockOutlined, MailOutlined, UserOutlined } from "@ant-design/icons";
import { Link, useNavigate } from "react-router-dom";
import { useState } from "react";
import { toast } from "react-toastify";
import { registerUser } from "../../services/apiUser";

const { Title, Paragraph } = Typography;

export default function Register() {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);

  const onFinish = async (values: any) => {
    setLoading(true);
    try {
      const res = await registerUser({
        name: values.name,
        email: values.email,
        password: values.password,
        repassword: values.repassword,
      });

      if (res?.status === "success") {
        toast.success("Đăng ký tài khoản thành công! Hãy đăng nhập.");
        navigate("/login");
      } else {
        toast.error(res?.message || "Đăng ký thất bại");
      }
    } catch (error: any) {
      console.error("Register error:", error);
      toast.error(
        error.response?.data?.message || "Đăng ký thất bại! Email có thể đã tồn tại."
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
            Đăng Ký
          </Title>
          <Paragraph type="secondary">Tạo tài khoản mua sắm tại D-Food!</Paragraph>
        </div>

        <Form
          name="register_form"
          onFinish={onFinish}
          layout="vertical"
          size="large"
        >
          <Form.Item
            name="name"
            rules={[{ required: true, message: "Vui lòng nhập Họ tên!" }]}
          >
            <Input
              prefix={<UserOutlined style={{ color: "var(--color-text-light)" }} />}
              placeholder="Họ và tên"
            />
          </Form.Item>

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
            rules={[
              { required: true, message: "Vui lòng nhập Mật khẩu!" },
              { min: 6, message: "Mật khẩu phải dài ít nhất 6 ký tự!" },
            ]}
          >
            <Input.Password
              prefix={<LockOutlined style={{ color: "var(--color-text-light)" }} />}
              placeholder="Mật khẩu"
            />
          </Form.Item>

          <Form.Item
            name="repassword"
            dependencies={["password"]}
            rules={[
              { required: true, message: "Vui lòng xác nhận Mật khẩu!" },
              ({ getFieldValue }) => ({
                validator(_, value) {
                  if (!value || getFieldValue("password") === value) {
                    return Promise.resolve();
                  }
                  return Promise.reject(new Error("Mật khẩu nhập lại không khớp!"));
                },
              }),
            ]}
          >
            <Input.Password
              prefix={<LockOutlined style={{ color: "var(--color-text-light)" }} />}
              placeholder="Xác nhận mật khẩu"
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
              Đăng Ký
            </Button>
          </Form.Item>
        </Form>

        <div style={{ textAlign: "center", marginTop: 16 }}>
          Đã có tài khoản?{" "}
          <Link to="/login" style={{ color: "var(--color-primary)", fontWeight: "500" }}>
            Đăng nhập ngay
          </Link>
        </div>
      </Card>
    </div>
  );
}
