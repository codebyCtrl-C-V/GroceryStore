import { useEffect, useState } from "react";
import {
  Table,
  Button,
  Space,
  Modal,
  Form,
  Input,
  Upload,
  Popconfirm,
  Typography,
  Card,
  message,
  Image
} from "antd";
import { PlusOutlined, EditOutlined, DeleteOutlined, UploadOutlined, SearchOutlined } from "@ant-design/icons";
import { getNews, searchNews, createNews, updateNews, deleteNews } from "../../services/apiAdmin";
import type { RcFile, UploadFile } from "antd/es/upload/interface";

const { Title, Paragraph } = Typography;
const { TextArea } = Input;

interface NewsArticle {
  id: number;
  title: string;
  slug: string;
  content: string;
  image: string;
  createdAt?: string;
  updatedAt?: string;
}

export default function AdminNews() {
  const [news, setNews] = useState<NewsArticle[]>([]);
  const [loading, setLoading] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  // Modal states
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingNews, setEditingNews] = useState<NewsArticle | null>(null);
  const [fileList, setFileList] = useState<UploadFile[]>([]);
  const [form] = Form.useForm();

  const fetchNewsList = async (page = 1, search = searchQuery) => {
    try {
      setLoading(true);
      let res;
      if (search.trim()) {
        res = await searchNews(search, page);
      } else {
        res = await getNews(page);
      }

      if (res?.status === "success" && res?.data) {
        setNews(res.data.news || []);
        setCurrentPage(res.data.currentPage || 1);
        setTotalPages(res.data.totalPages || 1);
      }
    } catch (err) {
      console.error("Lỗi lấy danh sách tin tức:", err);
      message.error("Không thể tải danh sách tin tức.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchNewsList(1, "");
  }, []);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    fetchNewsList(1, searchQuery);
  };

  const handlePageChange = (page: number) => {
    fetchNewsList(page, searchQuery);
  };

  const showModal = (article?: NewsArticle) => {
    if (article) {
      setEditingNews(article);
      form.setFieldsValue({
        title: article.title,
        content: article.content,
      });
      if (article.image) {
        setFileList([
          {
            uid: "-1",
            name: "image.png",
            status: "done",
            url: article.image,
          },
        ]);
      } else {
        setFileList([]);
      }
    } else {
      setEditingNews(null);
      form.resetFields();
      setFileList([]);
    }
    setIsModalOpen(true);
  };

  const handleCancel = () => {
    setIsModalOpen(false);
    form.resetFields();
    setFileList([]);
    setEditingNews(null);
  };

  const handleFinish = async (values: any) => {
    try {
      setLoading(true);
      const formData = new FormData();
      formData.append("title", values.title);
      formData.append("content", values.content);

      if (fileList.length > 0 && fileList[0].originFileObj) {
        formData.append("image", fileList[0].originFileObj as RcFile);
      }

      if (editingNews) {
        formData.append("id", String(editingNews.id));
        const res = await updateNews(formData);
        if (res?.status === "success") {
          message.success("Cập nhật tin tức thành công!");
          handleCancel();
          fetchNewsList(currentPage);
        } else {
          message.error("Cập nhật tin tức thất bại.");
        }
      } else {
        // Create requires an image, let's enforce this
        if (fileList.length === 0) {
          message.error("Vui lòng tải ảnh đại diện cho tin tức!");
          setLoading(false);
          return;
        }

        const res = await createNews(formData);
        if (res?.status === "success") {
          message.success("Thêm tin tức thành công!");
          handleCancel();
          fetchNewsList(1, "");
          setSearchQuery("");
        } else {
          message.error("Thêm tin tức thất bại.");
        }
      }
    } catch (err) {
      console.error(err);
      message.error("Có lỗi xảy ra khi lưu tin tức.");
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (id: number) => {
    try {
      setLoading(true);
      const res = await deleteNews(id);
      if (res?.status === "success") {
        message.success("Xóa tin tức thành công!");
        const isLastItem = news.length === 1 && currentPage > 1;
        fetchNewsList(isLastItem ? currentPage - 1 : currentPage);
      } else {
        message.error("Xóa tin tức thất bại.");
      }
    } catch (err) {
      console.error(err);
      message.error("Lỗi khi xóa tin tức.");
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
      title: "Ảnh bìa",
      dataIndex: "image",
      key: "image",
      width: 100,
      render: (imgSrc: string) => (
        <Image
          src={imgSrc || "/images/no-image.png"}
          alt="news"
          width={70}
          height={50}
          style={{ objectFit: "cover", borderRadius: 4 }}
          fallback="/images/no-image.png"
        />
      ),
    },
    {
      title: "Tiêu đề",
      dataIndex: "title",
      key: "title",
      sorter: (a: NewsArticle, b: NewsArticle) => a.title.localeCompare(b.title),
    },
    {
      title: "Nội dung tóm tắt",
      dataIndex: "content",
      key: "content",
      ellipsis: true,
      render: (content: string) => (
        <span>{content.length > 100 ? `${content.substring(0, 100)}...` : content}</span>
      ),
    },
    {
      title: "Ngày tạo",
      dataIndex: "createdAt",
      key: "createdAt",
      width: 180,
      render: (date: string) => date ? <span>{new Date(date).toLocaleDateString("vi-VN")}</span> : "-",
    },
    {
      title: "Hành động",
      key: "action",
      width: 180,
      render: (_: any, record: NewsArticle) => (
        <Space size="middle">
          <Button type="primary" icon={<EditOutlined />} onClick={() => showModal(record)} ghost>
            Sửa
          </Button>
          <Popconfirm
            title="Bạn có chắc muốn xóa tin tức này không?"
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
          <Title level={2}>Quản lý tin tức</Title>
          <Paragraph style={{ color: "var(--color-text-light)" }}>
            Đăng tin khuyến mãi, giới thiệu sản phẩm và thông tin của cửa hàng
          </Paragraph>
        </div>

        <Space style={{ flexWrap: "wrap" }}>
          {/* SEARCH FORM */}
          <form onSubmit={handleSearch} style={{ display: "flex", gap: 8 }}>
            <Input
              placeholder="Tìm theo tiêu đề hoặc nội dung..."
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
            Thêm bài viết
          </Button>
        </Space>
      </div>

      <Card bordered={false} style={{ boxShadow: "var(--shadow-sm)" }}>
        <Table
          dataSource={news}
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
        title={editingNews ? "Cập nhật bài viết" : "Đăng bài viết mới"}
        open={isModalOpen}
        onCancel={handleCancel}
        footer={null}
        width={750}
        destroyOnClose
      >
        <Form
          form={form}
          layout="vertical"
          onFinish={handleFinish}
          initialValues={{ title: "", content: "" }}
          style={{ marginTop: 16 }}
        >
          <Form.Item
            name="title"
            label="Tiêu đề bài viết"
            rules={[{ required: true, message: "Vui lòng nhập tiêu đề tin tức!" }]}
          >
            <Input placeholder="Tiêu đề bài viết" />
          </Form.Item>

          <Form.Item label="Hình ảnh minh họa">
            <Upload {...uploadProps} maxCount={1} listType="picture">
              <Button icon={<UploadOutlined />}>Tải ảnh lên</Button>
            </Upload>
          </Form.Item>

          <Form.Item
            name="content"
            label="Nội dung chi tiết"
            rules={[{ required: true, message: "Vui lòng nhập nội dung tin tức!" }]}
          >
            <TextArea rows={8} placeholder="Nhập nội dung bài viết tin tức tại đây..." />
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
