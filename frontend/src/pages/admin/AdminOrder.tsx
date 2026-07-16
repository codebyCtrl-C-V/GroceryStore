import { useEffect, useState } from "react";
import {
  Table,
  Button,
  Space,
  Modal,
  Select,
  Typography,
  Card,
  message,
  Tag,
  Descriptions,
  Divider,
  Input,
  Tabs
} from "antd";
import { EyeOutlined, SearchOutlined, CheckCircleOutlined, SyncOutlined, ClockCircleOutlined, CloseCircleOutlined } from "@ant-design/icons";
import { getOrders, getOrderDetail, updateOrderStatus, searchOrders } from "../../services/apiAdmin";

const { Title, Paragraph } = Typography;

interface Order {
  id: number;
  userId: number;
  name: string;
  phone: string;
  address: string;
  paymentMethod: string;
  total: number | string;
  status: "pending" | "processing" | "completed" | "cancelled";
  createdAt: string;
  User?: {
    name: string;
    email: string;
    phone: string;
  };
}

interface OrderDetailItem {
  id: number;
  orderId: number;
  productId: number;
  quantity: number;
  price: number | string;
  total: number | string;
  Product?: {
    name: string;
    image: string;
  };
}

export default function AdminOrder() {
  const [orders, setOrders] = useState<Order[]>([]);
  const [loading, setLoading] = useState(false);
  const [activeTab, setActiveTab] = useState("all");
  const [searchQuery, setSearchQuery] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  // Detail Modal
  const [detailModalOpen, setDetailModalOpen] = useState(false);
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(null);
  const [orderDetails, setOrderDetails] = useState<OrderDetailItem[]>([]);
  const [detailLoading, setDetailLoading] = useState(false);
  const [statusUpdating, setStatusUpdating] = useState(false);

  const fetchOrdList = async (page = 1, status = activeTab, search = searchQuery) => {
    try {
      setLoading(true);
      if (search.trim()) {
        const res = await searchOrders(search);
        if (res?.status === "success" && res?.data) {
          // searchOrders returns a single order in data: { order }
          setOrders(res.data.order ? [res.data.order] : []);
          setCurrentPage(1);
          setTotalPages(1);
        } else {
          setOrders([]);
          setCurrentPage(1);
          setTotalPages(1);
        }
      } else {
        const res = await getOrders(page, status);
        if (res?.status === "success" && res?.data) {
          setOrders(res.data.orders || []);
          setCurrentPage(res.data.currentPage || 1);
          setTotalPages(res.data.totalPages || 1);
        }
      }
    } catch (err) {
      console.error("Lỗi lấy danh sách đơn hàng:", err);
      message.error("Không thể tải danh sách đơn hàng.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchOrdList(1, activeTab, "");
  }, [activeTab]);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    fetchOrdList(1, activeTab, searchQuery);
  };

  const handlePageChange = (page: number) => {
    fetchOrdList(page, activeTab, searchQuery);
  };

  const handleTabChange = (key: string) => {
    setActiveTab(key);
    setSearchQuery("");
  };

  const viewDetails = async (orderId: number) => {
    try {
      setDetailLoading(true);
      setDetailModalOpen(true);
      const res = await getOrderDetail(orderId);
      if (res?.status === "success" && res?.data) {
        setSelectedOrder(res.data.order);
        setOrderDetails(res.data.orderDetails || []);
      }
    } catch (err) {
      console.error("Lỗi lấy chi tiết đơn hàng:", err);
      message.error("Không thể tải chi tiết đơn hàng.");
    } finally {
      setDetailLoading(false);
    }
  };

  const changeStatus = async (orderId: number, newStatus: string) => {
    try {
      setStatusUpdating(true);
      const res = await updateOrderStatus(orderId, newStatus);
      if (res?.status === "success") {
        message.success("Cập nhật trạng thái đơn hàng thành công!");
        fetchOrdList(currentPage, activeTab, searchQuery);
        
        // Refresh details modal if open
        if (selectedOrder && selectedOrder.id === orderId) {
          setSelectedOrder({ ...selectedOrder, status: newStatus as any });
        }
      } else {
        message.error("Cập nhật trạng thái thất bại.");
      }
    } catch (err) {
      console.error(err);
      message.error("Có lỗi xảy ra khi cập nhật trạng thái.");
    } finally {
      setStatusUpdating(false);
    }
  };

  const formatCurrency = (value: number | string) => {
    return new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND" }).format(Number(value));
  };

  const getStatusTag = (status: string) => {
    switch (status) {
      case "pending":
        return <Tag color="warning" icon={<ClockCircleOutlined />}>Chờ xử lý</Tag>;
      case "processing":
        return <Tag color="processing" icon={<SyncOutlined spin />}>Đang giao</Tag>;
      case "completed":
        return <Tag color="success" icon={<CheckCircleOutlined />}>Hoàn thành</Tag>;
      case "cancelled":
        return <Tag color="error" icon={<CloseCircleOutlined />}>Đã hủy</Tag>;
      default:
        return <Tag color="default">{status}</Tag>;
    }
  };

  const orderColumns = [
    {
      title: "Mã đơn hàng",
      dataIndex: "id",
      key: "id",
      width: 120,
      render: (id: number) => <strong>#{id}</strong>,
    },
    {
      title: "Khách hàng",
      dataIndex: "name",
      key: "name",
      render: (name: string, record: Order) => (
        <div>
          <div>{name}</div>
          <small style={{ color: "var(--color-text-light)" }}>{record.phone}</small>
        </div>
      ),
    },
    {
      title: "Địa chỉ nhận",
      dataIndex: "address",
      key: "address",
      ellipsis: true,
    },
    {
      title: "Phương thức thanh toán",
      dataIndex: "paymentMethod",
      key: "paymentMethod",
      render: (pm: string) => (
        <span style={{ textTransform: "uppercase" }}>{pm}</span>
      ),
    },
    {
      title: "Tổng tiền",
      dataIndex: "total",
      key: "total",
      render: (total: number) => <strong style={{ color: "var(--color-secondary)" }}>{formatCurrency(total)}</strong>,
    },
    {
      title: "Trạng thái",
      dataIndex: "status",
      key: "status",
      render: (status: string) => getStatusTag(status),
    },
    {
      title: "Ngày đặt",
      dataIndex: "createdAt",
      key: "createdAt",
      render: (date: string) => <span>{new Date(date).toLocaleString("vi-VN")}</span>,
    },
    {
      title: "Hành động",
      key: "action",
      width: 150,
      render: (_: any, record: Order) => (
        <Space size="small">
          <Button type="primary" icon={<EyeOutlined />} onClick={() => viewDetails(record.id)} ghost>
            Chi tiết
          </Button>
          <Select
            value={record.status}
            onChange={(val) => changeStatus(record.id, val)}
            size="small"
            style={{ width: 110 }}
            options={[
              { value: "pending", label: "Chờ xử lý" },
              { value: "processing", label: "Đang giao" },
              { value: "completed", label: "Hoàn thành" },
              { value: "cancelled", label: "Hủy đơn" },
            ]}
          />
        </Space>
      ),
    },
  ];

  const detailColumns = [
    {
      title: "Sản phẩm",
      dataIndex: ["Product", "name"],
      key: "productName",
      render: (name: string, record: OrderDetailItem) => (
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <img
            src={record.Product?.image || "/images/no-image.png"}
            alt={name}
            style={{ width: 40, height: 40, objectFit: "cover", borderRadius: 4 }}
          />
          <span>{name || "Sản phẩm đã bị xóa"}</span>
        </div>
      ),
    },
    {
      title: "Đơn giá",
      dataIndex: "price",
      key: "price",
      render: (price: number) => <span>{formatCurrency(price)}</span>,
    },
    {
      title: "Số lượng",
      dataIndex: "quantity",
      key: "quantity",
      render: (qty: number) => <span>{qty}</span>,
    },
    {
      title: "Thành tiền",
      dataIndex: "total",
      key: "total",
      render: (total: number) => <strong>{formatCurrency(total)}</strong>,
    },
  ];

  const tabItems = [
    { key: "all", label: "Tất cả đơn hàng" },
    { key: "pending", label: "Chờ xử lý" },
    { key: "processing", label: "Đang giao" },
    { key: "completed", label: "Đã hoàn thành" },
    { key: "cancelled", label: "Đã hủy" },
  ];

  return (
    <div>
      <div style={{ display: "flex", justifyContent: "between", alignItems: "center", marginBottom: 24, flexWrap: "wrap", gap: 16 }}>
        <div>
          <Title level={2}>Quản lý đơn hàng</Title>
          <Paragraph style={{ color: "var(--color-text-light)" }}>
            Theo dõi, cập nhật trạng thái đơn đặt hàng từ khách hàng
          </Paragraph>
        </div>

        <div>
          {/* SEARCH FORM */}
          <form onSubmit={handleSearch} style={{ display: "flex", gap: 8 }}>
            <Input
              placeholder="Nhập mã đơn hàng (ID)..."
              prefix={<SearchOutlined style={{ color: "var(--color-text-light)" }} />}
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              style={{ width: 220 }}
              allowClear
            />
            <Button type="primary" htmlType="submit">
              Tìm đơn
            </Button>
          </form>
        </div>
      </div>

      <Card bordered={false} style={{ boxShadow: "var(--shadow-sm)" }}>
        <Tabs activeKey={activeTab} onChange={handleTabChange} items={tabItems} style={{ marginBottom: 16 }} />
        
        <Table
          dataSource={orders}
          columns={orderColumns}
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

      {/* Detail Modal */}
      <Modal
        title={`Chi tiết đơn hàng #${selectedOrder?.id}`}
        open={detailModalOpen}
        onCancel={() => setDetailModalOpen(false)}
        footer={[
          <Button key="close" onClick={() => setDetailModalOpen(false)}>
            Đóng lại
          </Button>
        ]}
        width={800}
        loading={detailLoading}
      >
        {selectedOrder && (
          <div>
            <Descriptions title="Thông tin khách hàng" bordered size="small" style={{ marginTop: 16 }}>
              <Descriptions.Item label="Họ tên">{selectedOrder.name}</Descriptions.Item>
              <Descriptions.Item label="Số điện thoại">{selectedOrder.phone}</Descriptions.Item>
              <Descriptions.Item label="Phương thức thanh toán">
                <span style={{ textTransform: "uppercase" }}>{selectedOrder.paymentMethod}</span>
              </Descriptions.Item>
              <Descriptions.Item label="Địa chỉ giao hàng" span={3}>
                {selectedOrder.address}
              </Descriptions.Item>
            </Descriptions>

            <Divider style={{ margin: "20px 0 12px" }}>Danh sách mặt hàng</Divider>
            
            <Table
              dataSource={orderDetails}
              columns={detailColumns}
              rowKey="id"
              pagination={false}
              size="small"
              summary={() => (
                <Table.Summary fixed>
                  <Table.Summary.Row>
                    <Table.Summary.Cell index={0} colSpan={3}>
                      <div style={{ textAlign: "right", fontWeight: "bold" }}>
                        Tổng cộng tiền thanh toán:
                      </div>
                    </Table.Summary.Cell>
                    <Table.Summary.Cell index={1}>
                      <strong style={{ color: "var(--color-secondary)", fontSize: 16 }}>
                        {formatCurrency(selectedOrder.total)}
                      </strong>
                    </Table.Summary.Cell>
                  </Table.Summary.Row>
                </Table.Summary>
              )}
            />

            <Divider style={{ margin: "20px 0 12px" }} />
            
            <div style={{ display: "flex", justifyContent: "between", alignItems: "center" }}>
              <Space>
                <span>Trạng thái đơn hàng:</span>
                {getStatusTag(selectedOrder.status)}
              </Space>
              
              <Space>
                <span>Cập nhật nhanh:</span>
                <Select
                  value={selectedOrder.status}
                  onChange={(val) => changeStatus(selectedOrder.id, val)}
                  loading={statusUpdating}
                  style={{ width: 140 }}
                  options={[
                    { value: "pending", label: "Chờ xử lý" },
                    { value: "processing", label: "Đang giao" },
                    { value: "completed", label: "Hoàn thành" },
                    { value: "cancelled", label: "Hủy đơn hàng" },
                  ]}
                />
              </Space>
            </div>
          </div>
        )}
      </Modal>
    </div>
  );
}
