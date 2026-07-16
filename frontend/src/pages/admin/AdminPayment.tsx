import { useEffect, useState } from "react";
import {
  Table,
  Button,
  Select,
  Typography,
  Card,
  message,
  Tag,
  Input,
  Tabs
} from "antd";
import { SearchOutlined, CheckCircleOutlined, ClockCircleOutlined, CloseCircleOutlined } from "@ant-design/icons";
import { getPayments, updatePaymentStatus, searchPayment } from "../../services/apiAdmin";

const { Title, Paragraph } = Typography;

interface Payment {
  id: number;
  orderId: number;
  paymentMethod: "cod" | "online" | string;
  status: "pending" | "paid" | "failed";
  createdAt: string;
  updatedAt: string;
}

export default function AdminPayment() {
  const [payments, setPayments] = useState<Payment[]>([]);
  const [loading, setLoading] = useState(false);
  const [activeTab, setActiveTab] = useState("all");
  const [searchQuery, setSearchQuery] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [statusUpdating, setStatusUpdating] = useState(false);

  const fetchPaymentsList = async (page = 1, status = activeTab, search = searchQuery) => {
    try {
      setLoading(true);
      if (search.trim()) {
        const res = await searchPayment(search);
        if (res?.status === "success" && res?.data) {
          // searchPayment returns a single payment in data: { payment }
          setPayments(res.data.payment ? [res.data.payment] : []);
          setCurrentPage(1);
          setTotalPages(1);
        } else {
          setPayments([]);
          setCurrentPage(1);
          setTotalPages(1);
        }
      } else {
        const res = await getPayments(page, status);
        if (res?.status === "success" && res?.data) {
          setPayments(res.data.payments || []);
          setCurrentPage(res.data.currentPage || 1);
          setTotalPages(res.data.totalPages || 1);
        }
      }
    } catch (err) {
      console.error("Lỗi lấy danh sách giao dịch thanh toán:", err);
      message.error("Không thể tải danh sách giao dịch thanh toán.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchPaymentsList(1, activeTab, "");
  }, [activeTab]);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    fetchPaymentsList(1, activeTab, searchQuery);
  };

  const handlePageChange = (page: number) => {
    fetchPaymentsList(page, activeTab, searchQuery);
  };

  const handleTabChange = (key: string) => {
    setActiveTab(key);
    setSearchQuery("");
  };

  const changeStatus = async (paymentId: number, newStatus: string) => {
    try {
      setStatusUpdating(true);
      const res = await updatePaymentStatus(paymentId, newStatus);
      if (res?.status === "success") {
        message.success("Cập nhật trạng thái thanh toán thành công!");
        fetchPaymentsList(currentPage, activeTab, searchQuery);
      } else {
        message.error("Cập nhật trạng thái thất bại.");
      }
    } catch (err) {
      console.error(err);
      message.error("Có lỗi xảy ra khi cập nhật trạng thái thanh toán.");
    } finally {
      setStatusUpdating(false);
    }
  };

  const getStatusTag = (status: string) => {
    switch (status) {
      case "pending":
        return <Tag color="warning" icon={<ClockCircleOutlined />}>Chờ thanh toán</Tag>;
      case "paid":
        return <Tag color="success" icon={<CheckCircleOutlined />}>Đã thanh toán</Tag>;
      case "failed":
        return <Tag color="error" icon={<CloseCircleOutlined />}>Thất bại</Tag>;
      default:
        return <Tag color="default">{status}</Tag>;
    }
  };

  const columns = [
    {
      title: "ID",
      dataIndex: "id",
      key: "id",
      width: 80,
      render: (id: number) => <strong>#{id}</strong>,
    },
    {
      title: "Mã đơn hàng",
      dataIndex: "orderId",
      key: "orderId",
      width: 150,
      render: (orderId: number) => (
        <span>Đơn hàng #{orderId}</span>
      ),
    },
    {
      title: "Phương thức",
      dataIndex: "paymentMethod",
      key: "paymentMethod",
      render: (pm: string) => (
        <Tag color={pm === "online" ? "purple" : "cyan"}>
          {pm === "online" ? "Thanh toán Online" : "Thanh toán khi nhận hàng (COD)"}
        </Tag>
      ),
    },
    {
      title: "Trạng thái",
      dataIndex: "status",
      key: "status",
      render: (status: string) => getStatusTag(status),
    },
    {
      title: "Ngày cập nhật",
      dataIndex: "updatedAt",
      key: "updatedAt",
      render: (date: string) => <span>{new Date(date).toLocaleString("vi-VN")}</span>,
    },
    {
      title: "Hành động cập nhật",
      key: "action",
      width: 200,
      render: (_: any, record: Payment) => (
        <Select
          value={record.status}
          onChange={(val) => changeStatus(record.id, val)}
          loading={statusUpdating}
          style={{ width: 160 }}
          options={[
            { value: "pending", label: "Chờ thanh toán" },
            { value: "paid", label: "Đã thanh toán" },
            { value: "failed", label: "Thất bại" },
          ]}
        />
      ),
    },
  ];

  const tabItems = [
    { key: "all", label: "Tất cả giao dịch" },
    { key: "pending", label: "Chờ thanh toán" },
    { key: "paid", label: "Đã thanh toán" },
    { key: "failed", label: "Thất bại" },
  ];

  return (
    <div>
      <div style={{ display: "flex", justifyContent: "between", alignItems: "center", marginBottom: 24, flexWrap: "wrap", gap: 16 }}>
        <div>
          <Title level={2}>Quản lý thanh toán</Title>
          <Paragraph style={{ color: "var(--color-text-light)" }}>
            Kiểm tra trạng thái giao dịch thanh toán trực tuyến hoặc COD của đơn hàng
          </Paragraph>
        </div>

        <div>
          {/* SEARCH FORM */}
          <form onSubmit={handleSearch} style={{ display: "flex", gap: 8 }}>
            <Input
              placeholder="Nhập mã đơn hàng (OrderID)..."
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
        </div>
      </div>

      <Card bordered={false} style={{ boxShadow: "var(--shadow-sm)" }}>
        <Tabs activeKey={activeTab} onChange={handleTabChange} items={tabItems} style={{ marginBottom: 16 }} />

        <Table
          dataSource={payments}
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
    </div>
  );
}
