import { Card, Typography, Spin, Button, Breadcrumb } from "antd";
import { ClockCircleOutlined, ArrowLeftOutlined } from "@ant-design/icons";
import { useEffect, useState } from "react";
import { useParams, Link } from "react-router-dom";
import dayjs from "dayjs";
import { getNewsDetail } from "../../services/apiNews";

const { Title } = Typography;

interface Article {
  title: string;
  content: string;
  image: string;
  updatedAt: string;
}

export default function NewsDetail() {
  const { slug } = useParams<{ slug: string }>();
  const [article, setArticle] = useState<Article | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchDetail = async () => {
      if (!slug) return;
      setLoading(true);
      try {
        const res = await getNewsDetail(slug);
        if (res?.status === "success" && res?.data?.news) {
          setArticle(res.data.news);
        }
      } catch (error) {
        console.error("Error fetching news detail:", error);
      } finally {
        setLoading(false);
      }
    };
    fetchDetail();
  }, [slug]);

  if (loading) {
    return (
      <div style={{ textAlign: "center", padding: "100px 0" }}>
        <Spin size="large" />
      </div>
    );
  }

  if (!article) {
    return (
      <div style={{ textAlign: "center", padding: "50px 0" }}>
        <Title level={3}>Không tìm thấy bài viết</Title>
        <Link to="/news">
          <Button type="primary" style={{ background: "var(--color-primary)", borderColor: "var(--color-primary)" }}>
            Quay lại trang tin tức
          </Button>
        </Link>
      </div>
    );
  }

  return (
    <div style={{ maxWidth: 800, margin: "20px auto", padding: "0 20px" }}>
      <Breadcrumb style={{ marginBottom: 20 }}>
        <Breadcrumb.Item>
          <Link to="/">Trang chủ</Link>
        </Breadcrumb.Item>
        <Breadcrumb.Item>
          <Link to="/news">Tin tức</Link>
        </Breadcrumb.Item>
        <Breadcrumb.Item>Chi tiết bài viết</Breadcrumb.Item>
      </Breadcrumb>

      <Card
        style={{
          borderRadius: 12,
          boxShadow: "var(--shadow-md)",
          border: "none",
          textAlign: "left",
        }}
      >
        <Title level={2} style={{ margin: "10px 0 16px 0", fontSize: "28px" }}>
          {article.title}
        </Title>

        <div style={{ display: "flex", gap: "16px", color: "var(--color-text-light)", marginBottom: 24, fontSize: "14px" }}>
          <span>
            <ClockCircleOutlined style={{ marginRight: 6 }} />
            Đăng ngày: {dayjs(article.updatedAt).format("DD/MM/YYYY")}
          </span>
        </div>

        {article.image && (
          <div style={{ textAlign: "center", marginBottom: 30 }}>
            <img
              src={article.image}
              alt={article.title}
              style={{
                maxWidth: "100%",
                maxHeight: 400,
                borderRadius: 8,
                objectFit: "cover",
              }}
            />
          </div>
        )}

        <div
          className="news-content"
          style={{ fontSize: "16px", lineHeight: "1.8", color: "var(--color-text)", wordBreak: "break-word" }}
          dangerouslySetInnerHTML={{ __html: article.content }}
        />

        <div style={{ borderTop: "1px solid var(--color-border)", marginTop: 40, paddingTop: 20 }}>
          <Link to="/news">
            <Button icon={<ArrowLeftOutlined />} size="large">
              Quay lại danh sách tin tức
            </Button>
          </Link>
        </div>
      </Card>
    </div>
  );
}
