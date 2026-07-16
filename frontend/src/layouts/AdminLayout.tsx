import { useState } from "react";
import { Layout, Menu, Button, Avatar, Dropdown, Space, theme } from "antd";
import {
  DashboardOutlined,
  AppstoreOutlined,
  ShoppingOutlined,
  FileTextOutlined,
  CreditCardOutlined,
  UserOutlined,
  ReadOutlined,
  MenuUnfoldOutlined,
  MenuFoldOutlined,
  HomeOutlined,
  LogoutOutlined,
} from "@ant-design/icons";
import { Link, Outlet, useLocation, useNavigate } from "react-router-dom";
import useAuth from "../hooks/useAuth";
import type { MenuProps } from "antd";

const { Header, Sider, Content } = Layout;

export default function AdminLayout() {
  const { userInfor, logout } = useAuth();
  const [collapsed, setCollapsed] = useState(false);
  const navigate = useNavigate();
  const location = useLocation();

  const {
    token: { colorBgContainer, borderRadiusLG },
  } = theme.useToken();

  const menuItems = [
    {
      key: "/admin/dashboard",
      icon: <DashboardOutlined />,
      label: "Dashboard",
    },
    {
      key: "/admin/category",
      icon: <AppstoreOutlined />,
      label: "Danh mục",
    },
    {
      key: "/admin/product",
      icon: <ShoppingOutlined />,
      label: "Sản phẩm",
    },
    {
      key: "/admin/order",
      icon: <FileTextOutlined />,
      label: "Đơn hàng",
    },
    {
      key: "/admin/payment",
      icon: <CreditCardOutlined />,
      label: "Thanh toán",
    },
    {
      key: "/admin/user",
      icon: <UserOutlined />,
      label: "Người dùng",
    },
    {
      key: "/admin/news",
      icon: <ReadOutlined />,
      label: "Tin tức",
    },
  ];

  const handleMenuClick: MenuProps["onClick"] = (e) => {
    navigate(e.key);
  };

  const userMenuItems: MenuProps["items"] = [
    {
      key: "home",
      icon: <HomeOutlined />,
      label: <Link to="/">Về trang chủ</Link>,
    },
    {
      key: "logout",
      icon: <LogoutOutlined />,
      danger: true,
      label: "Đăng xuất",
      onClick: () => logout(),
    },
  ];

  return (
    <Layout style={{ minHeight: "100vh" }}>
      <Sider trigger={null} collapsible collapsed={collapsed} theme="dark" width={240}>
        <div style={{ height: 64, margin: 16, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <Link to="/" style={{ display: 'flex', alignItems: 'center', gap: 10, textDecoration: 'none' }}>
            <img src="/images/logo.png" alt="logo" style={{ height: 40 }} />
            {!collapsed && (
              <span style={{ color: '#fff', fontSize: 18, fontWeight: 'bold' }}>
                ADMIN PANEL
              </span>
            )}
          </Link>
        </div>
        <Menu
          theme="dark"
          mode="inline"
          selectedKeys={[location.pathname]}
          items={menuItems}
          onClick={handleMenuClick}
        />
      </Sider>
      <Layout>
        <Header style={{ padding: "0 24px 0 0", background: colorBgContainer, display: 'flex', justifyContent: 'between', alignItems: 'center' }}>
          <Button
            type="text"
            icon={collapsed ? <MenuUnfoldOutlined /> : <MenuFoldOutlined />}
            onClick={() => setCollapsed(!collapsed)}
            style={{
              fontSize: '16px',
              width: 64,
              height: 64,
            }}
          />
          
          <div style={{ flex: 1 }}></div>

          <Space size="middle">
            <Button type="link" icon={<HomeOutlined />} onClick={() => navigate('/')}>
              Xem cửa hàng
            </Button>
            <Dropdown menu={{ items: userMenuItems }} placement="bottomRight" arrow>
              <Space style={{ cursor: 'pointer', padding: '0 8px' }}>
                <Avatar icon={<UserOutlined />} style={{ backgroundColor: 'var(--color-primary)' }} />
                <span style={{ fontWeight: 500, color: 'var(--color-text)' }}>
                  {userInfor?.name || "Admin"}
                </span>
              </Space>
            </Dropdown>
          </Space>
        </Header>
        <Content
          style={{
            margin: '24px 16px',
            padding: 24,
            minHeight: 280,
            background: colorBgContainer,
            borderRadius: borderRadiusLG,
            overflowY: 'auto'
          }}
        >
          <Outlet />
        </Content>
      </Layout>
    </Layout>
  );
}
