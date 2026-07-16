import { useEffect, useState } from "react";
import {
  Table,
  Button,
  Space,
  Modal,
  Form,
  Input,
  Select,
  Popconfirm,
  Typography,
  Card,
  message,
  Tag,
  Row,
  Col
} from "antd";
import { PlusOutlined, EditOutlined, DeleteOutlined, SearchOutlined } from "@ant-design/icons";
import { getUsers, searchUsers, createUser, updateUser, deleteUser } from "../../services/apiAdmin";

const { Title, Paragraph } = Typography;

interface User {
  id: number;
  name: string;
  email: string;
  phone?: string;
  address?: string;
  role: "customer" | "admin";
  createdAt?: string;
}

export default function AdminUser() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  // Modal State
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingUser, setEditingUser] = useState<User | null>(null);
  const [form] = Form.useForm();

  const fetchUserList = async (page = 1, search = searchQuery) => {
    try {
      setLoading(true);
      let res;
      if (search.trim()) {
        res = await searchUsers(search, page);
      } else {
        res = await getUsers(page);
      }

      if (res?.status === "success" && res?.data) {
        setUsers(res.data.users || []);
        setCurrentPage(res.data.currentPage || 1);
        setTotalPages(res.data.totalPages || 1);
      }
    } catch (err) {
      console.error("Lỗi lấy danh sách người dùng:", err);
      message.error("Không thể tải danh sách tài khoản.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchUserList(1, "");
  }, []);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    fetchUserList(1, searchQuery);
  };

  const handlePageChange = (page: number) => {
    fetchUserList(page, searchQuery);
  };

  const showModal = (user?: User) => {
    if (user) {
      setEditingUser(user);
      form.setFieldsValue({
        name: user.name,
        email: user.email,
        phone: user.phone,
        address: user.address,
        role: user.role,
      });
    } else {
      setEditingUser(null);
      form.resetFields();
    }
    setIsModalOpen(true);
  };

  const handleCancel = () => {
    setIsModalOpen(false);
    form.resetFields();
    setEditingUser(null);
  };

  const handleFinish = async (values: any) => {
    try {
      setLoading(true);
      if (editingUser) {
        // Cập nhật người dùng
        const res = await updateUser({
          id: editingUser.id,
          name: values.name,
          email: values.email,
          phone: values.phone,
          address: values.address,
          role: values.role,
        });

        if (res?.status === "success") {
          message.success("Cập nhật tài khoản thành công!");
          handleCancel();
          fetchUserList(currentPage);
        } else {
          message.error("Cập nhật tài khoản thất bại.");
        }
      } else {
        // Tạo người dùng mới
        const res = await createUser({
          name: values.name,
          email: values.email,
          password: values.password,
          phone: values.phone,
          address: values.address,
          role: values.role,
        });

        if (res?.status === "success") {
          message.success("Thêm tài khoản thành công!");
          handleCancel();
          fetchUserList(1, "");
          setSearchQuery("");
        } else {
          message.error("Thêm tài khoản thất bại (Email có thể đã được đăng ký).");
        }
      }
    } catch (err) {
      console.error(err);
      message.error("Có lỗi xảy ra khi lưu tài khoản.");
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (id: number) => {
    try {
      setLoading(true);
      const res = await deleteUser(id);
      if (res?.status === "success") {
        message.success("Xóa tài khoản thành công!");
        const isLastItem = users.length === 1 && currentPage > 1;
        fetchUserList(isLastItem ? currentPage - 1 : currentPage);
      } else {
        message.error("Xóa tài khoản thất bại.");
      }
    } catch (err) {
      console.error(err);
      message.error("Lỗi khi xóa tài khoản.");
    } finally {
      setLoading(false);
    }
  };

  const columns = [
    {
      title: "ID",
      dataIndex: "id",
      key: "id",
      width: 80,
    },
    {
      title: "Họ tên",
      dataIndex: "name",
      key: "name",
      sorter: (a: User, b: User) => a.name.localeCompare(b.name),
    },
    {
      title: "Email",
      dataIndex: "email",
      key: "email",
    },
    {
      title: "Số điện thoại",
      dataIndex: "phone",
      key: "phone",
      render: (phone: string) => phone || <span style={{ color: "#d9d9d9" }}>Chưa cập nhật</span>,
    },
    {
      title: "Địa chỉ",
      dataIndex: "address",
      key: "address",
      ellipsis: true,
      render: (address: string) => address || <span style={{ color: "#d9d9d9" }}>Chưa cập nhật</span>,
    },
    {
      title: "Quyền hạn",
      dataIndex: "role",
      key: "role",
      width: 130,
      render: (role: string) => (
        <Tag color={role === "admin" ? "red" : "green"}>
          {role === "admin" ? "Quản trị viên" : "Khách hàng"}
        </Tag>
      ),
    },
    {
      title: "Hành động",
      key: "action",
      width: 180,
      render: (_: any, record: User) => (
        <Space size="middle">
          <Button type="primary" icon={<EditOutlined />} onClick={() => showModal(record)} ghost>
            Sửa
          </Button>
          <Popconfirm
            title="Bạn có chắc muốn xóa tài khoản này?"
            description="Tài khoản này sẽ bị xóa vĩnh viễn."
            onConfirm={() => handleDelete(record.id)}
            okText="Đồng ý"
            cancelText="Hủy"
            okButtonProps={{ danger: true }}
          >
            <Button type="primary" danger icon={<DeleteOutlined />} ghost>
              Xóa
            </Button>
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <div>
      <div style={{ display: "flex", justifyContent: "between", alignItems: "center", marginBottom: 24, flexWrap: "wrap", gap: 16 }}>
        <div>
          <Title level={2}>Quản lý người dùng</Title>
          <Paragraph style={{ color: "var(--color-text-light)" }}>
            Danh sách khách hàng và quản trị viên của hệ thống
          </Paragraph>
        </div>

        <Space style={{ flexWrap: "wrap" }}>
          {/* SEARCH FORM */}
          <form onSubmit={handleSearch} style={{ display: "flex", gap: 8 }}>
            <Input
              placeholder="Tìm theo tên hoặc email..."
              prefix={<SearchOutlined style={{ color: "var(--color-text-light)" }} />}
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              style={{ width: 220 }}
              allowClear
            />
            <Button type="primary" htmlType="submit">
              Tìm kiếm
            </Button>
          </form>

          <Button
            type="primary"
            icon={<PlusOutlined />}
            onClick={() => showModal()}
            style={{ backgroundColor: "var(--color-primary)", borderColor: "var(--color-primary)" }}
          >
            Thêm tài khoản
          </Button>
        </Space>
      </div>

      <Card bordered={false} style={{ boxShadow: "var(--shadow-sm)" }}>
        <Table
          dataSource={users}
          columns={columns}
          rowKey="id"
          loading={loading}
          pagination={{
            current: currentPage,
            total: totalPages * 10,
            pageSize: 10,
            onChange: handlePageChange,
            showSizeChanger: false
          }}
        />
      </Card>

      {/* Modal Add/Edit */}
      <Modal
        title={editingUser ? "Cập nhật tài khoản" : "Tạo tài khoản mới"}
        open={isModalOpen}
        onCancel={handleCancel}
        footer={null}
        destroyOnClose
      >
        <Form
          form={form}
          layout="vertical"
          onFinish={handleFinish}
          initialValues={{ name: "", email: "", password: "", phone: "", address: "", role: "customer" }}
          style={{ marginTop: 16 }}
        >
          <Form.Item
            name="name"
            label="Họ và tên"
            rules={[{ required: true, message: "Vui lòng nhập họ tên người dùng!" }]}
          >
            <Input placeholder="Nhập họ và tên" />
          </Form.Item>

          <Row gutter={16}>
            <Col span={12}>
              <Form.Item
                name="email"
                label="Email"
                rules={[
                  { required: true, message: "Vui lòng nhập email!" },
                  { type: "email", message: "Email không hợp lệ!" }
                ]}
              >
                <Input placeholder="name@example.com" disabled={!!editingUser} />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item
                name="role"
                label="Quyền hạn"
                rules={[{ required: true, message: "Chọn quyền hạn!" }]}
              >
                <Select>
                  <Select.Option value="customer">Khách hàng</Select.Option>
                  <Select.Option value="admin">Quản trị viên</Select.Option>
                </Select>
              </Form.Item>
            </Col>
          </Row>

          {!editingUser && (
            <Form.Item
              name="password"
              label="Mật khẩu"
              rules={[
                { required: true, message: "Vui lòng nhập mật khẩu cho tài khoản mới!" },
                { min: 6, message: "Mật khẩu phải từ 6 ký tự trở lên!" }
              ]}
            >
              <Input.Password placeholder="Nhập mật khẩu tài khoản" />
            </Form.Item>
          )}

          <Form.Item
            name="phone"
            label="Số điện thoại"
          >
            <Input placeholder="Nhập số điện thoại" />
          </Form.Item>

          <Form.Item
            name="address"
            label="Địa chỉ"
          >
            <Input.TextArea rows={2} placeholder="Nhập địa chỉ nhà riêng" />
          </Form.Item>

          <Form.Item style={{ display: "flex", justifyContent: "end", marginBottom: 0, marginTop: 24 }}>
            <Space>
              <Button onClick={handleCancel}>Hủy</Button>
              <Button
                type="primary"
                htmlType="submit"
                loading={loading}
                style={{ backgroundColor: "var(--color-primary)", borderColor: "var(--color-primary)" }}
              >
                Lưu lại
              </Button>
            </Space>
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
