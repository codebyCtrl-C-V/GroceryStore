import { Layout } from "antd";
import MainHeader from "./mainHeader/MainHeader";
const { Content } = Layout;
import { Outlet } from "react-router-dom";
import Footer from "./footer/Footers";
import useAuth from "../hooks/useAuth";
import { useEffect, useState } from "react";
import { getAllCategories } from "../services/apiCategory";

export default function Layouts() {
  const { userInfor } = useAuth();
  const [categories, setCategories] = useState<{ name: string; slug: string }[]>([]);

  useEffect(() => {
    const fetchCats = async () => {
      try {
        const res = await getAllCategories();
        if (res?.status === "success" && Array.isArray(res?.data)) {
          setCategories(res.data);
        }
      } catch (err) {
        console.error("Lỗi lấy danh mục ở Layouts:", err);
      }
    };
    fetchCats();
  }, []);

  return (
    <Layout>
      <MainHeader user={userInfor} categories={categories} />
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
