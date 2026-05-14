import { Layout } from 'antd';
import Headers from './header/Headers';
const { Content } = Layout;
import { Outlet } from "react-router-dom";

export default function LayoutAuth() {
  return (
    <Layout>
      <Headers />
      <Content
        style={{ padding: '0 50px', background: "var(--color-bg)", minHeight: '100vh' }}
        className="small-layout"
      >
        <Outlet />
      </Content>
    </Layout>
  );
}
