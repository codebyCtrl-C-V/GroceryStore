import { Card, Typography, Tabs, Button, Tag, Space, Spin, Empty, List, Divider } from "antd";
import { ClockCircleOutlined, DollarOutlined, CloseCircleOutlined } from "@ant-design/icons";
import { useEffect, useState } from "react";
import { toast } from "react-toastify";
import dayjs from "dayjs";
import { getOrders, cancelOrder } from "../../services/apiOrder";

const { Title, Text } = Typography;

interface OrderDetail {
  product: {
    name: string;
    image: string;
  };
  quantity: number;
  price: number;
  total: number;
}

interface Order {
  id: number;
  status: string;
  total: number;
  createdAt: string;
  paymentMethod: string;
  details: OrderDetail[];
}

export default function Orders() {
  const [orders, setOrders] = useState<{
    pendingOrders: Order[];
    processingOrders: Order[];
    completedOrders: Order[];
    cancelledOrders: Order[];
  }>({
    pendingOrders: [],
    processingOrders: [],
    completedOrders: [],
    cancelledOrders: [],
  });
  const [loading, setLoading] = useState(true);
  const [cancellingId, setCancellingId] = useState<number | null>(null);

  const fetchUserOrders = async () => {
    try {
      const res = await getOrders();
      if (res?.status === "success" && res?.data) {
        setOrders(res.data);
      }
    } catch (error) {
      console.error("Error fetching orders:", error);
      toast.error("Không thể lấy danh sách đơn hàng.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchUserOrders();
  }, []);

  const handleCancelOrder = async (orderId: number) => {
    if (!window.confirm("Bạn có chắc chắn muốn hủy đơn hàng này không?")) return;

    setCancellingId(orderId);
    try {
      const res = await cancelOrder(orderId);
      if (res?.status === "success") {
        toast.success("Đã hủy đơn hàng thành công!");
        fetchUserOrders(); // Re-fetch list
      } else {
        toast.error(res?.message || "Không thể hủy đơn hàng.");
      }
    } catch (error) {
      console.error("Cancel order error:", error);
      toast.error("Hủy đơn hàng thất bại.");
    } finally {
      setCancellingId(null);
    }
  };

  const getStatusTag = (status: string) => {
    switch (status) {
      case "pending":
        return <Tag color="warning">Chờ xử lý</Tag>;
      case "processing":
        return <Tag color="processing">Đang xử lý</Tag>;
      case "completed":
        return <Tag color="success">Đã giao</Tag>;
      case "cancelled":
        return <Tag color="error">Đã hủy</Tag>;
      default:
        return <Tag>{status}</Tag>;
    }
  };

  const getPaymentMethodText = (method: string) => {
    return method === "cod" ? "Thanh toán tiền mặt (COD)" : "Thanh toán trực tuyến (VNPAY)";
  };

  const renderOrderList = (orderList: Order[]) => {
    if (orderList.length === 0) {
      return <Empty description="Không có đơn hàng nào trong trạng thái này" style={{ padding: "40px 0" }} />;
    }

    return (
      <Space direction="vertical" size="large" style={{ width: "100%" }}>
        {orderList.map((order) => (
          <Card
            key={order.id}
            style={{ borderRadius: 12, boxShadow: "var(--shadow-sm)", border: "1px solid var(--color-border)", textAlign: "left" }}
            title={
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", flexWrap: "wrap", gap: "8px", padding: "4px 0" }}>
                <span>
                  <strong>Đơn hàng: #{order.id}</strong>
                </span>
                <span>{getStatusTag(order.status)}</span>
              </div>
            }
          >
            <div style={{ marginBottom: 16, fontSize: "14px", color: "var(--color-text-light)" }}>
              <Space split={<Divider type="vertical" />}>
                <span>
                  <ClockCircleOutlined style={{ marginRight: 6 }} />
                  Ngày đặt: {dayjs(order.createdAt).format("DD/MM/YYYY HH:mm")}
                </span>
                <span>Phương thức: {getPaymentMethodText(order.paymentMethod)}</span>
              </Space>
            </div>

            <List
              itemLayout="horizontal"
              dataSource={order.details}
              renderItem={(detail) => (
                <List.Item style={{ padding: "10px 0" }}>
                  <List.Item.Meta
                    avatar={
                      <img
                        src={detail.product.image}
                        alt={detail.product.name}
                        style={{ width: 50, height: 50, objectFit: "contain", borderRadius: 4, border: "1px solid var(--color-border)" }}
                      />
                    }
                    title={<span style={{ fontWeight: 600 }}>{detail.product.name}</span>}
                    description={
                      <Text type="secondary" style={{ fontSize: "13px" }}>
                        Số lượng: {detail.quantity} x {detail.price.toLocaleString("vi-VN")} VND
                      </Text>
                    }
                  />
                  <div>
                    <strong style={{ color: "var(--color-text)" }}>
                      {detail.total.toLocaleString("vi-VN")} VND
                    </strong>
                  </div>
                </List.Item>
              )}
            />

            <Divider style={{ margin: "16px 0" }} />

            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", flexWrap: "wrap", gap: "16px" }}>
              <div>
                <Space>
                  <DollarOutlined style={{ color: "var(--color-secondary)", fontSize: "18px" }} />
                  <span style={{ fontSize: "15px" }}>Tổng thanh toán:</span>
                  <strong style={{ fontSize: "18px", color: "var(--color-secondary)" }}>
                    {order.total.toLocaleString("vi-VN")} VND
                  </strong>
                </Space>
              </div>

              {order.status === "pending" && (
                <Button
                  danger
                  type="primary"
                  icon={<CloseCircleOutlined />}
                  loading={cancellingId === order.id}
                  onClick={() => handleCancelOrder(order.id)}
                  style={{ borderRadius: 6 }}
                >
                  Hủy đơn hàng
                </Button>
              )}
            </div>
          </Card>
        ))}
      </Space>
    );
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
      key: "pending",
      label: `Chờ xử lý (${orders.pendingOrders.length})`,
      children: renderOrderList(orders.pendingOrders),
    },
    {
      key: "processing",
      label: `Đang xử lý (${orders.processingOrders.length})`,
      children: renderOrderList(orders.processingOrders),
    },
    {
      key: "completed",
      label: `Đã giao hàng (${orders.completedOrders.length})`,
      children: renderOrderList(orders.completedOrders),
    },
    {
      key: "cancelled",
      label: `Đã hủy (${orders.cancelledOrders.length})`,
      children: renderOrderList(orders.cancelledOrders),
    },
  ];

  return (
    <div style={{ maxWidth: 850, margin: "20px auto", padding: "0 20px" }}>
      <Title level={2} style={{ marginBottom: 24, textAlign: "left" }}>
        Đơn Hàng Của Tôi
      </Title>

      <Tabs defaultActiveKey="pending" items={items} size="large" />
    </div>
  );
}
