import { Card, Typography, Tabs, Form, Input, Button, Spin } from "antd";
import { UserOutlined, LockOutlined, PhoneOutlined, HomeOutlined } from "@ant-design/icons";
import { useEffect, useState } from "react";
import { toast } from "react-toastify";
import { getProfile, updateProfile, changePassword } from "../../services/apiUser";
import useAuth from "../../hooks/useAuth";

const { Title, Paragraph } = Typography;

export default function Profile() {
  const { fetchUserInfor } = useAuth();
  const [loading, setLoading] = useState(true);
  const [updating, setUpdating] = useState(false);
  const [changingPass, setChangingPass] = useState(false);
  const [profileForm] = Form.useForm();
  const [passwordForm] = Form.useForm();

  const fetchUserProfile = async () => {
    setLoading(true);
    try {
      const res = await getProfile();
      if (res?.status === "success" && res?.data) {
        profileForm.setFieldsValue({
          name: res.data.name,
          phone: res.data.phone || "",
          address: res.data.address || "",
        });
      }
    } catch (error) {
      console.error("Error fetching profile:", error);
      toast.error("Không thể lấy thông tin tài khoản.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchUserProfile();
  }, []);

  const onUpdateProfile = async (values: any) => {
    setUpdating(true);
    try {
      const res = await updateProfile(values);
      if (res?.status === "success") {
        toast.success("Cập nhật thông tin tài khoản thành công!");
        await fetchUserInfor(); // Cập nhật state auth toàn cục
      } else {
        toast.error(res?.message || "Cập nhật thất bại.");
      }
    } catch (error: any) {
      console.error("Update profile error:", error);
      toast.error(error.response?.data?.message || "Có lỗi xảy ra khi cập nhật!");
    } finally {
      setUpdating(false);
    }
  };

  const onChangePassword = async (values: any) => {
    setChangingPass(true);
    try {
      const res = await changePassword({
        oldpass: values.oldpass,
        newpass: values.newpass,
        renewpass: values.renewpass,
      });

      if (res?.status === "success") {
        toast.success("Đổi mật khẩu thành công!");
        passwordForm.resetFields();
      } else {
        toast.error(res?.message || "Đổi mật khẩu thất bại.");
      }
    } catch (error: any) {
      console.error("Change password error:", error);
      toast.error(error.response?.data?.message || "Đổi mật khẩu thất bại!");
    } finally {
      setChangingPass(false);
    }
  };

  if (loading) {
    return (
      <div style={{ textAlign: "center", padding: "100px 0" }}>
        <Spin size="large" />
      </div>
    );
  }

  const items = [
    {
      key: "profile",
      label: "Thông tin cá nhân",
      children: (
        <Form
          form={profileForm}
          onFinish={onUpdateProfile}
          layout="vertical"
          size="large"
          style={{ marginTop: 10 }}
        >
          <Form.Item
            name="name"
            label="Họ và tên"
            rules={[{ required: true, message: "Vui lòng nhập Họ tên!" }]}
          >
            <Input prefix={<UserOutlined />} placeholder="Họ và tên" />
          </Form.Item>

          <Form.Item name="phone" label="Số điện thoại">
            <Input prefix={<PhoneOutlined />} placeholder="Số điện thoại" />
          </Form.Item>

          <Form.Item name="address" label="Địa chỉ giao hàng">
            <Input prefix={<HomeOutlined />} placeholder="Địa chỉ giao hàng" />
          </Form.Item>

          <Form.Item style={{ marginTop: 24 }}>
            <Button
              type="primary"
              htmlType="submit"
              loading={updating}
              style={{
                background: "var(--color-primary)",
                borderColor: "var(--color-primary)",
                borderRadius: "6px",
                width: "150px",
              }}
            >
              Lưu thay đổi
            </Button>
          </Form.Item>
        </Form>
      ),
    },
    {
      key: "password",
      label: "Đổi mật khẩu",
      children: (
        <Form
          form={passwordForm}
          onFinish={onChangePassword}
          layout="vertical"
          size="large"
          style={{ marginTop: 10 }}
        >
          <Form.Item
            name="oldpass"
            label="Mật khẩu hiện tại"
            rules={[{ required: true, message: "Vui lòng nhập Mật khẩu hiện tại!" }]}
          >
            <Input.Password prefix={<LockOutlined />} placeholder="Mật khẩu hiện tại" />
          </Form.Item>

          <Form.Item
            name="newpass"
            label="Mật khẩu mới"
            rules={[
              { required: true, message: "Vui lòng nhập Mật khẩu mới!" },
              { min: 6, message: "Mật khẩu phải dài ít nhất 6 ký tự!" },
            ]}
          >
            <Input.Password prefix={<LockOutlined />} placeholder="Mật khẩu mới" />
          </Form.Item>

          <Form.Item
            name="renewpass"
            label="Xác nhận mật khẩu mới"
            dependencies={["newpass"]}
            rules={[
              { required: true, message: "Vui lòng xác nhận Mật khẩu mới!" },
              ({ getFieldValue }) => ({
                validator(_, value) {
                  if (!value || getFieldValue("newpass") === value) {
                    return Promise.resolve();
                  }
                  return Promise.reject(new Error("Mật khẩu mới nhập lại không khớp!"));
                },
              }),
            ]}
          >
            <Input.Password prefix={<LockOutlined />} placeholder="Xác nhận mật khẩu mới" />
          </Form.Item>

          <Form.Item style={{ marginTop: 24 }}>
            <Button
              type="primary"
              htmlType="submit"
              loading={changingPass}
              style={{
                background: "var(--color-primary)",
                borderColor: "var(--color-primary)",
                borderRadius: "6px",
                width: "150px",
              }}
            >
              Đổi mật khẩu
            </Button>
          </Form.Item>
        </Form>
      ),
    },
  ];

  return (
    <div style={{ maxWidth: 650, margin: "30px auto", padding: "0 20px" }}>
      <Card
        style={{
          borderRadius: 16,
          boxShadow: "var(--shadow-md)",
          border: "none",
          textAlign: "left",
        }}
      >
        <div style={{ textAlign: "center", marginBottom: 24 }}>
          <Title level={2} style={{ color: "var(--color-primary)", margin: 0 }}>
            Tài Khoản Của Tôi
          </Title>
          <Paragraph type="secondary">
            Cập nhật hồ sơ cá nhân và thay đổi mật khẩu tài khoản
          </Paragraph>
        </div>

        <Tabs defaultActiveKey="profile" items={items} />
      </Card>
    </div>
  );
}
