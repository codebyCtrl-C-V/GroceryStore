import { useEffect, useState } from "react";
import { Card, Col, Row, Statistic, Table, Typography, Spin, Alert, Progress, Space, Tag } from "antd";
import {
  ShoppingOutlined,
  FileTextOutlined,
  UserOutlined,
  DollarCircleOutlined,
  ClockCircleOutlined,
  CheckCircleOutlined,
  CloseCircleOutlined,
  SyncOutlined
} from "@ant-design/icons";
import { getDashboard, getOrderStatistics } from "../../services/apiAdmin";

const { Title, Paragraph } = Typography;

interface DashboardData {
  totalProducts: number;
  totalOrders: number;
  totalUsers: number;
}

interface OrderStatsData {
  statusStats: { status: string; count: number | string }[];
  monthlyRevenue: number | string;
  dailyOrders: { date: string; count: number }[];
}

export default function AdminDashboard() {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [dashboardData, setDashboardData] = useState<DashboardData | null>(null);
  const [statsData, setStatsData] = useState<OrderStatsData | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const [dashRes, statsRes] = await Promise.all([
          getDashboard(),
          getOrderStatistics()
        ]);

        if (dashRes?.status === "success") {
          setDashboardData(dashRes.data);
        }
        if (statsRes?.status === "success") {
          setStatsData(statsRes.data);
        }
      } catch (err: any) {
        console.error("Lỗi lấy dữ liệu dashboard:", err);
        setError("Không thể tải dữ liệu thống kê. Vui lòng thử lại sau.");
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  if (loading) {
    return (
      <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '400px' }}>
        <Spin size="large" tip="Đang tải dữ liệu dashboard..." />
      </div>
    );
  }

  if (error) {
    return <Alert message="Lỗi" description={error} type="error" showIcon />;
  }

  const formatCurrency = (value: number | string) => {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(Number(value));
  };

  // Map status values to vietnamese and icons
  const getStatusMeta = (status: string) => {
    switch (status) {
      case "pending":
        return { label: "Chờ xử lý", color: "warning", icon: <ClockCircleOutlined /> };
      case "processing":
        return { label: "Đang giao", color: "processing", icon: <SyncOutlined spin /> };
      case "completed":
        return { label: "Đã hoàn thành", color: "success", icon: <CheckCircleOutlined /> };
      case "cancelled":
        return { label: "Đã hủy", color: "error", icon: <CloseCircleOutlined /> };
      default:
        return { label: status, color: "default", icon: null };
    }
  };

  const totalStatusOrders = statsData?.statusStats.reduce((acc, curr) => acc + Number(curr.count), 0) || 1;

  const dailyOrdersColumns = [
    {
      title: "Ngày",
      dataIndex: "date",
      key: "date",
      render: (text: string) => <span>{new Date(text).toLocaleDateString('vi-VN')}</span>
    },
    {
      title: "Số đơn hàng",
      dataIndex: "count",
      key: "count",
      render: (text: number) => <Tag color="green">{text} đơn</Tag>
    }
  ];

  return (
    <div>
      <div style={{ marginBottom: 24 }}>
        <Title level={2}>Tổng quan hệ thống</Title>
        <Paragraph style={{ color: "var(--color-text-light)" }}>
          Thống kê hoạt động bán hàng và quản trị của GroceryStore
        </Paragraph>
      </div>

      {/* METRIC CARDS */}
      <Row gutter={[16, 16]} style={{ marginBottom: 24 }}>
        <Col xs={24} sm={12} md={6}>
          <Card bordered={false} style={{ boxShadow: 'var(--shadow-sm)', borderLeft: '4px solid #16a34a' }}>
            <Statistic
              title="Tổng sản phẩm"
              value={dashboardData?.totalProducts || 0}
              prefix={<ShoppingOutlined style={{ color: '#16a34a', marginRight: 8 }} />}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} md={6}>
          <Card bordered={false} style={{ boxShadow: 'var(--shadow-sm)', borderLeft: '4px solid #f97316' }}>
            <Statistic
              title="Tổng đơn hàng"
              value={dashboardData?.totalOrders || 0}
              prefix={<FileTextOutlined style={{ color: '#f97316', marginRight: 8 }} />}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} md={6}>
          <Card bordered={false} style={{ boxShadow: 'var(--shadow-sm)', borderLeft: '4px solid #3b82f6' }}>
            <Statistic
              title="Người dùng"
              value={dashboardData?.totalUsers || 0}
              prefix={<UserOutlined style={{ color: '#3b82f6', marginRight: 8 }} />}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} md={6}>
          <Card bordered={false} style={{ boxShadow: 'var(--shadow-sm)', borderLeft: '4px solid #a855f7' }}>
            <Statistic
              title="Doanh thu tháng này"
              value={statsData?.monthlyRevenue ? Number(statsData.monthlyRevenue) : 0}
              formatter={(value) => formatCurrency(Number(value))}
              prefix={<DollarCircleOutlined style={{ color: '#a855f7', marginRight: 8 }} />}
            />
          </Card>
        </Col>
      </Row>

      <Row gutter={[24, 24]}>
        {/* ORDER STATUS DISTRIBUTION */}
        <Col xs={24} md={12}>
          <Card title="Trạng thái đơn hàng" bordered={false} style={{ height: '100%', boxShadow: 'var(--shadow-sm)' }}>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 20 }}>
              {statsData?.statusStats.map((item) => {
                const percent = Math.round((Number(item.count) / totalStatusOrders) * 100);
                const meta = getStatusMeta(item.status);
                return (
                  <div key={item.status}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 8, alignItems: 'center' }}>
                      <Space>
                        <span style={{ display: 'flex', alignItems: 'center' }}>{meta.icon}</span>
                        <span style={{ fontWeight: 500 }}>{meta.label}</span>
                      </Space>
                      <span>
                        <strong>{item.count} đơn</strong> ({percent}%)
                      </span>
                    </div>
                    <Progress
                      percent={percent}
                      status={item.status === 'cancelled' ? 'exception' : 'normal'}
                      strokeColor={
                        item.status === 'completed'
                          ? '#16a34a'
                          : item.status === 'processing'
                          ? '#3b82f6'
                          : item.status === 'pending'
                          ? '#f97316'
                          : '#ef4444'
                      }
                      showInfo={false}
                    />
                  </div>
                );
              })}
              {(!statsData?.statusStats || statsData.statusStats.length === 0) && (
                <div style={{ textAlign: 'center', padding: '40px 0', color: 'var(--color-text-light)' }}>
                  Không có đơn hàng nào
                </div>
              )}
            </div>
          </Card>
        </Col>

        {/* DAILY ORDERS LIST */}
        <Col xs={24} md={12}>
          <Card title="Số đơn đặt hàng hàng ngày (Tháng này)" bordered={false} style={{ height: '100%', boxShadow: 'var(--shadow-sm)' }}>
            <Table
              dataSource={statsData?.dailyOrders || []}
              columns={dailyOrdersColumns}
              rowKey="date"
              pagination={{ pageSize: 5 }}
              size="middle"
              locale={{ emptyText: "Không có dữ liệu cho tháng này" }}
            />
          </Card>
        </Col>
      </Row>
    </div>
  );
}
