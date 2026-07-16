import { useEffect, useState } from "react";
import {
  Table,
  Button,
  Space,
  Modal,
  Form,
  Input,
  InputNumber,
  Select,
  Upload,
  Popconfirm,
  Typography,
  Card,
  message,
  Image,
  Tag,
  Row,
  Col
} from "antd";
import { PlusOutlined, EditOutlined, DeleteOutlined, UploadOutlined, SearchOutlined } from "@ant-design/icons";
import { getProducts, searchProducts, createProduct, updateProduct, deleteProduct } from "../../services/apiAdmin";
import type { RcFile, UploadFile } from "antd/es/upload/interface";

const { Title, Paragraph } = Typography;
const { TextArea } = Input;

interface Category {
  id: number;
  name: string;
  slug: string;
}

interface Product {
  id: number;
  name: string;
  slug: string;
  description: string;
  price: number | string;
  stock: number;
  image: string;
  sale: number;
  category_id: number;
  createdAt?: string;
  updatedAt?: string;
}

export default function AdminProduct() {
  const [products, setProducts] = useState<Product[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(false);
  
  // Search & Pagination
  const [searchQuery, setSearchQuery] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  // Modal states
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingProduct, setEditingProduct] = useState<Product | null>(null);
  const [fileList, setFileList] = useState<UploadFile[]>([]);
  const [form] = Form.useForm();

  const fetchProds = async (page = 1, search = searchQuery) => {
    try {
      setLoading(true);
      let res;
      if (search.trim()) {
        res = await searchProducts(search, page);
      } else {
        res = await getProducts(page);
      }

      if (res?.status === "success" && res?.data) {
        setProducts(res.data.products || []);
        setCategories(res.data.categories || []);
        setCurrentPage(res.data.currentPage || 1);
        setTotalPages(res.data.totalPages || 1);
      }
    } catch (err: any) {
      console.error("Lỗi lấy danh sách sản phẩm:", err);
      message.error("Không thể tải danh sách sản phẩm.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchProds(1, "");
  }, []);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    fetchProds(1, searchQuery);
  };

  const handlePageChange = (page: number) => {
    fetchProds(page, searchQuery);
  };

  const showModal = (product?: Product) => {
    if (product) {
      setEditingProduct(product);
      form.setFieldsValue({
        name: product.name,
        price: product.price,
        stock: product.stock,
        description: product.description,
        sale: product.sale,
        category_id: product.category_id,
      });
      if (product.image) {
        setFileList([
          {
            uid: "-1",
            name: "image.png",
            status: "done",
            url: product.image,
          },
        ]);
      } else {
        setFileList([]);
      }
    } else {
      setEditingProduct(null);
      form.resetFields();
      setFileList([]);
    }
    setIsModalOpen(true);
  };

  const handleCancel = () => {
    setIsModalOpen(false);
    form.resetFields();
    setFileList([]);
    setEditingProduct(null);
  };

  const handleFinish = async (values: any) => {
    try {
      setLoading(true);
      const formData = new FormData();
      formData.append("name", values.name);
      formData.append("price", String(values.price));
      formData.append("stock", String(values.stock));
      formData.append("description", values.description || "");
      formData.append("sale", String(values.sale || 0));
      formData.append("category_id", String(values.category_id));

      if (fileList.length > 0 && fileList[0].originFileObj) {
        formData.append("image", fileList[0].originFileObj as RcFile);
      }

      if (editingProduct) {
        formData.append("id", String(editingProduct.id));
        const res = await updateProduct(formData);
        if (res?.status === "success") {
          message.success("Cập nhật sản phẩm thành công!");
          handleCancel();
          fetchProds(currentPage);
        } else {
          message.error("Cập nhật sản phẩm thất bại.");
        }
      } else {
        const res = await createProduct(formData);
        if (res?.status === "success") {
          message.success("Thêm sản phẩm thành công!");
          handleCancel();
          fetchProds(1, "");
          setSearchQuery("");
        } else {
          message.error("Thêm sản phẩm thất bại.");
        }
      }
    } catch (err) {
      console.error(err);
      message.error("Có lỗi xảy ra trong quá trình lưu sản phẩm.");
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (id: number) => {
    try {
      setLoading(true);
      const res = await deleteProduct(id);
      if (res?.status === "success") {
        message.success("Xóa sản phẩm thành công!");
        // Refresh products list
        const isLastItemOnPage = products.length === 1 && currentPage > 1;
        fetchProds(isLastItemOnPage ? currentPage - 1 : currentPage);
      } else {
        message.error("Xóa sản phẩm thất bại.");
      }
    } catch (err) {
      console.error(err);
      message.error("Lỗi khi xóa sản phẩm.");
    } finally {
      setLoading(false);
    }
  };

  const formatCurrency = (value: number | string) => {
    return new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND" }).format(Number(value));
  };

  const getCategoryName = (catId: number) => {
    const cat = categories.find((c) => c.id === catId);
    return cat ? cat.name : "N/A";
  };

  const columns = [
    {
      title: "ID",
      dataIndex: "id",
      key: "id",
      width: 60,
    },
    {
      title: "Ảnh",
      dataIndex: "image",
      key: "image",
      width: 80,
      render: (imgSrc: string) => (
        <Image
          src={imgSrc || "/images/no-image.png"}
          alt="sp"
          width={50}
          height={50}
          style={{ objectFit: "cover", borderRadius: 4 }}
          fallback="/images/no-image.png"
        />
      ),
    },
    {
      title: "Tên sản phẩm",
      dataIndex: "name",
      key: "name",
      sorter: (a: Product, b: Product) => a.name.localeCompare(b.name),
    },
    {
      title: "Danh mục",
      dataIndex: "category_id",
      key: "category_id",
      render: (catId: number) => <Tag color="blue">{getCategoryName(catId)}</Tag>,
    },
    {
      title: "Giá bán",
      dataIndex: "price",
      key: "price",
      render: (price: number) => <span>{formatCurrency(price)}</span>,
    },
    {
      title: "Khuyến mãi",
      dataIndex: "sale",
      key: "sale",
      render: (sale: number) => (
        sale > 0 ? <Tag color="volcano">Giảm {sale}%</Tag> : <Tag color="gray">Không</Tag>
      ),
    },
    {
      title: "Tồn kho",
      dataIndex: "stock",
      key: "stock",
      render: (stock: number) => (
        stock <= 5 ? <Tag color="red">Còn {stock}</Tag> : <span>{stock}</span>
      ),
    },
    {
      title: "Hành động",
      key: "action",
      width: 180,
      render: (_: any, record: Product) => (
        <Space size="middle">
          <Button type="primary" icon={<EditOutlined />} onClick={() => showModal(record)} ghost>
            Sửa
          </Button>
          <Popconfirm
            title="Bạn có chắc muốn xóa sản phẩm này?"
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

  const uploadProps = {
    onRemove: () => {
      setFileList([]);
    },
    beforeUpload: (file: RcFile) => {
      setFileList([file]);
      return false; // prevent upload via antd
    },
    fileList,
  };

  return (
    <div>
      <div style={{ display: "flex", justifyContent: "between", alignItems: "center", marginBottom: 24, flexWrap: "wrap", gap: 16 }}>
        <div>
          <Title level={2}>Quản lý sản phẩm</Title>
          <Paragraph style={{ color: "var(--color-text-light)" }}>
            Thêm, chỉnh sửa và quản lý sản phẩm trong kho hàng
          </Paragraph>
        </div>
        
        <Space style={{ flexWrap: "wrap" }}>
          {/* SEARCH FORM */}
          <form onSubmit={handleSearch} style={{ display: "flex", gap: 8 }}>
            <Input
              placeholder="Tìm kiếm sản phẩm..."
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
            Thêm sản phẩm
          </Button>
        </Space>
      </div>

      <Card bordered={false} style={{ boxShadow: "var(--shadow-sm)" }}>
        <Table
          dataSource={products}
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
        title={editingProduct ? "Cập nhật sản phẩm" : "Thêm sản phẩm mới"}
        open={isModalOpen}
        onCancel={handleCancel}
        footer={null}
        width={700}
        destroyOnClose
      >
        <Form
          form={form}
          layout="vertical"
          onFinish={handleFinish}
          initialValues={{ name: "", price: 0, stock: 0, sale: 0, description: "", category_id: undefined }}
          style={{ marginTop: 16 }}
        >
          <Row gutter={16}>
            <Col span={24}>
              <Form.Item
                name="name"
                label="Tên sản phẩm"
                rules={[{ required: true, message: "Vui lòng nhập tên sản phẩm!" }]}
              >
                <Input placeholder="Tên sản phẩm" />
              </Form.Item>
            </Col>
          </Row>

          <Row gutter={16}>
            <Col span={8}>
              <Form.Item
                name="price"
                label="Giá bán (VND)"
                rules={[{ required: true, message: "Nhập giá bán!" }]}
              >
                <InputNumber min={0} style={{ width: "100%" }} formatter={(val) => `${val}`.replace(/\B(?=(\d{3})+(?!\d))/g, ",")} />
              </Form.Item>
            </Col>
            <Col span={8}>
              <Form.Item
                name="stock"
                label="Số lượng tồn"
                rules={[{ required: true, message: "Nhập số lượng!" }]}
              >
                <InputNumber min={0} style={{ width: "100%" }} />
              </Form.Item>
            </Col>
            <Col span={8}>
              <Form.Item
                name="sale"
                label="Khuyến mãi (%)"
                rules={[{ required: true, message: "Nhập phần trăm giảm!" }]}
              >
                <InputNumber min={0} max={100} style={{ width: "100%" }} />
              </Form.Item>
            </Col>
          </Row>

          <Row gutter={16}>
            <Col span={12}>
              <Form.Item
                name="category_id"
                label="Danh mục"
                rules={[{ required: true, message: "Chọn danh mục sản phẩm!" }]}
              >
                <Select placeholder="Chọn danh mục">
                  {categories.map((c) => (
                    <Select.Option key={c.id} value={c.id}>
                      {c.name}
                    </Select.Option>
                  ))}
                </Select>
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item label="Hình ảnh sản phẩm">
                <Upload {...uploadProps} maxCount={1} listType="picture">
                  <Button icon={<UploadOutlined />}>Tải ảnh lên</Button>
                </Upload>
              </Form.Item>
            </Col>
          </Row>

          <Form.Item name="description" label="Mô tả sản phẩm">
            <TextArea rows={4} placeholder="Nhập chi tiết mô tả về sản phẩm..." />
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
