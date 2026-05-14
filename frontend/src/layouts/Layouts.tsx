import { Layout } from "antd";
import MainHeader from "./mainHeader/MainHeader";
const { Content } = Layout;
import { Outlet } from "react-router-dom";
import Footer from "./footer/Footers";

export default function Layouts() {
  const user = null;
  const categories = [
    { name: "trái cây tươi", slug: "trai-cay-tuoi" },
    { name: "hải sản tươi", slug: "hai-san-tuoi" },
    { name: "thịt tươi", slug: "thit-tuoi" },
  ];
  return (
    <Layout>
      <MainHeader user={user} categories={categories} />
      <Content
        style={{
          padding: "20px 50px 10px 50px",
          minHeight: "calc(100vh - 50px)",
          position: "relative",
          backgroundColor: "var(--color-bg)",
        }}
        className="small-layout"
      >
        <Outlet />
      </Content>
      <Footer />
    </Layout>
  );
}
