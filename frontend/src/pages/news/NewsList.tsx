import { Card, Typography, Row, Col, Pagination, Empty, Spin } from "antd";
import { ClockCircleOutlined } from "@ant-design/icons";
import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import dayjs from "dayjs";
import { getAllNews } from "../../services/apiNews";

const { Title, Paragraph } = Typography;

interface Article {
  id: number;
  title: string;
  slug: string;
  content: string;
  image: string;
  updatedAt: string;
}

export default function NewsList() {
  const [articles, setArticles] = useState<Article[]>([]);
  const [loading, setLoading] = useState(false);
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  const fetchArticles = async (page: number) => {
    setLoading(true);
    try {
      const res = await getAllNews(page);
      if (res?.status === "success" && res?.data) {
        setArticles(res.data.news || []);
        setCurrentPage(Number(res.data.currentPage) || 1);
        setTotalPages(res.data.totalPages || 1);
      }
    } catch (error) {
      console.error("Error fetching news list:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchArticles(currentPage);
  }, [currentPage]);

  const stripHtml = (html: string) => {
    const tmp = document.createElement("DIV");
    tmp.innerHTML = html;
    return tmp.textContent || tmp.innerText || "";
  };

  return (
    <div style={{ maxWidth: 1200, margin: "20px auto", padding: "0 20px" }}>
      <div style={{ textAlign: "center", marginBottom: 30 }}>
        <Title level={1} style={{ color: "var(--color-primary)", margin: "10px 0" }}>
          Tin Tức & Cẩm Nang
        </Title>
        <Paragraph type="secondary">
          Cập nhật thông tin thực phẩm sạch, bí quyết nấu ăn ngon và các chương trình khuyến mãi tại D-Food
        </Paragraph>
      </div>

      {loading ? (
        <div style={{ textAlign: "center", padding: "100px 0" }}>
          <Spin size="large" />
        </div>
      ) : articles.length === 0 ? (
        <Empty description="Chưa có tin tức nào được đăng" />
      ) : (
        <>
          <Row gutter={[24, 24]}>
            {articles.map((item) => (
              <Col xs={24} sm={12} lg={8} key={item.id}>
                <Card
                  hoverable
                  cover={
                    <Link to={`/news/${item.slug}`}>
                      <img
                        alt={item.title}
                        src={item.image || "/images/default-news.png"}
                        style={{
                          height: 200,
                          width: "100%",
                          objectFit: "cover",
                          borderTopLeftRadius: 8,
                          borderTopRightRadius: 8,
                        }}
                      />
                    </Link>
                  }
                  style={{
                    borderRadius: 8,
                    boxShadow: "var(--shadow-sm)",
                    border: "1px solid var(--color-border)",
                    height: "100%",
                    display: "flex",
                    flexDirection: "column",
                  }}
                  bodyStyle={{
                    flex: 1,
                    display: "flex",
                    flexDirection: "column",
                    justifyContent: "between",
                    padding: "20px",
                  }}
                >
                  <div>
                    <span style={{ color: "var(--color-text-light)", fontSize: "13px" }}>
                      <ClockCircleOutlined style={{ marginRight: 6 }} />
                      {dayjs(item.updatedAt).format("DD/MM/YYYY")}
                    </span>
                    <Title level={4} style={{ margin: "10px 0 12px 0", fontSize: "18px", lineHeight: "1.4" }}>
                      <Link to={`/news/${item.slug}`} style={{ color: "inherit" }}>
                        {item.title}
                      </Link>
                    </Title>
                    <Paragraph
                      type="secondary"
                      ellipsis={{ rows: 3 }}
                      style={{ fontSize: "14px", marginBottom: 20 }}
                    >
                      {stripHtml(item.content)}
                    </Paragraph>
                  </div>
                  <Link
                    to={`/news/${item.slug}`}
                    style={{
                      color: "var(--color-primary)",
                      fontWeight: "bold",
                      marginTop: "auto",
                      display: "inline-block",
                    }}
                  >
                    Xem chi tiết →
                  </Link>
                </Card>
              </Col>
            ))}
          </Row>

          <div style={{ textAlign: "center", marginTop: 40 }}>
            <Pagination
              current={currentPage}
              total={totalPages * 10}
              onChange={(page) => setCurrentPage(page)}
              showSizeChanger={false}
            />
          </div>
        </>
      )}
    </div>
  );
}
