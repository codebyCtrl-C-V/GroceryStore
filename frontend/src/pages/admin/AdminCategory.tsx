import { useEffect, useState } from "react";
import { Table, Button, Space, Modal, Form, Input, Popconfirm, Typography, Card, Alert, message } from "antd";
import { PlusOutlined, EditOutlined, DeleteOutlined } from "@ant-design/icons";
import { getCategories, createCategory, updateCategory, deleteCategory } from "../../services/apiAdmin";

const { Title, Paragraph } = Typography;

interface Category {
  id: number;
  name: string;
  slug: string;
  createdAt?: string;
  updatedAt?: string;
}

export default function AdminCategory() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Modal states
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingCategory, setEditingCategory] = useState<Category | null>(null);
  const [form] = Form.useForm();

  const fetchCats = async () => {
    try {
      setLoading(true);
      setError(null);
      const res = await getCategories();
      if (res?.status === "success" && Array.isArray(res?.data?.categories)) {
        setCategories(res.data.categories);
      }
    } catch (err: any) {
      console.error("Lỗi lấy danh mục:", err);
      setError("Không thể tải danh sách danh mục sản phẩm.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchCats();
  }, []);

  const showModal = (category?: Category) => {
    if (category) {
      setEditingCategory(category);
      form.setFieldsValue({
        name: category.name,
        slug: category.slug,
      });
    } else {
      setEditingCategory(null);
      form.resetFields();
    }
    setIsModalOpen(true);
  };

  const handleCancel = () => {
    setIsModalOpen(false);
    form.resetFields();
    setEditingCategory(null);
  };

  const handleFinish = async (values: { name: string; slug?: string }) => {
    try {
      setLoading(true);
      if (editingCategory) {
        // Slug generation logic: Slugify can be computed or user customizes it.
        // If slug isn't changed, we can pass what is there, or let it auto-generate or pass the updated form value.
        const defaultSlug = values.slug || values.name.toLowerCase().replace(/ /g, "-");
        const res = await updateCategory(editingCategory.id, values.name, defaultSlug);
        if (res?.status === "success") {
          message.success("Cập nhật danh mục thành công!");
          handleCancel();
          fetchCats();
        } else {
          message.error("Cập nhật danh mục thất bại.");
        }
      } else {
        const res = await createCategory(values.name);
        if (res?.status === "success") {
          message.success("Thêm danh mục thành công!");
          handleCancel();
          fetchCats();
        } else {
          message.error("Thêm danh mục thất bại.");
        }
      }
    } catch (err) {
      console.error(err);
      message.error("Lỗi xảy ra trong quá trình xử lý.");
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (id: number) => {
    try {
      setLoading(true);
      const res = await deleteCategory(id);
      if (res?.status === "success") {
        message.success("Xóa danh mục thành công!");
        fetchCats();
      } else {
        message.error("Xóa danh mục thất bại.");
      }
    } catch (err) {
      console.error(err);
      message.error("Lỗi khi xóa danh mục.");
    } finally {
      setLoading(false);
    }
  };

  // Auto populate slug when typing name (if adding new, or optionally updating)
  const onNameChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (!editingCategory) {
      const value = e.target.value;
      // Simple slugify: replace accents/special chars, spaces with '-'
      const slugValue = value
        .toLowerCase()
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "")
        .replace(/[đĐ]/g, "d")
        .replace(/[^a-z0-9\s-]/g, "")
        .replace(/\s+/g, "-")
        .replace(/-+/g, "-")
        .trim();
      form.setFieldValue("slug", slugValue);
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
      title: "Tên danh mục",
      dataIndex: "name",
      key: "name",
      sorter: (a: Category, b: Category) => a.name.localeCompare(b.name),
    },
    {
      title: "Slug",
      dataIndex: "slug",
      key: "slug",
    },
    {
      title: "Hành động",
      key: "action",
      width: 200,
      render: (_: any, record: Category) => (
        <Space size="middle">
          <Button
            type="primary"
            icon={<EditOutlined />}
            onClick={() => showModal(record)}
            ghost
          >
            Sửa
          </Button>
          <Popconfirm
            title="Bạn có chắc muốn xóa danh mục này?"
            description="Lưu ý: Xóa danh mục có thể ảnh hưởng đến các sản phẩm thuộc danh mục này."
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
      <div style={{ display: 'flex', justifyContent: 'between', alignItems: 'center', marginBottom: 24 }}>
        <div>
          <Title level={2}>Quản lý danh mục</Title>
          <Paragraph style={{ color: "var(--color-text-light)" }}>
            Danh sách danh mục sản phẩm của cửa hàng
          </Paragraph>
        </div>
        <Button
          type="primary"
          icon={<PlusOutlined />}
          onClick={() => showModal()}
          style={{ backgroundColor: 'var(--color-primary)', borderColor: 'var(--color-primary)' }}
        >
          Thêm danh mục
        </Button>
      </div>

      {error && (
        <Alert
          message="Lỗi"
          description={error}
          type="error"
          showIcon
          style={{ marginBottom: 16 }}
        />
      )}

      <Card bordered={false} style={{ boxShadow: 'var(--shadow-sm)' }}>
        <Table
          dataSource={categories}
          columns={columns}
          rowKey="id"
          loading={loading}
          pagination={{ pageSize: 10 }}
        />
      </Card>

      {/* Modal Add/Edit */}
      <Modal
        title={editingCategory ? "Cập nhật danh mục" : "Thêm danh mục mới"}
        open={isModalOpen}
        onCancel={handleCancel}
        footer={null}
        destroyOnClose
      >
        <Form
          form={form}
          layout="vertical"
          onFinish={handleFinish}
          initialValues={{ name: "", slug: "" }}
          style={{ marginTop: 16 }}
        >
          <Form.Item
            name="name"
            label="Tên danh mục"
            rules={[{ required: true, message: "Vui lòng nhập tên danh mục!" }]}
          >
            <Input placeholder="Nhập tên danh mục (ví dụ: Trái cây)" onChange={onNameChange} />
          </Form.Item>

          <Form.Item
            name="slug"
            label="Slug danh mục"
            rules={[{ required: true, message: "Vui lòng nhập slug!" }]}
          >
            <Input placeholder="slug-danh-muc" />
          </Form.Item>

          <Form.Item style={{ display: 'flex', justifyContent: 'end', marginBottom: 0, marginTop: 24 }}>
            <Space>
              <Button onClick={handleCancel}>Hủy</Button>
              <Button
                type="primary"
                htmlType="submit"
                loading={loading}
                style={{ backgroundColor: 'var(--color-primary)', borderColor: 'var(--color-primary)' }}
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
