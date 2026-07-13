import styles from "./mainHeader.module.css";
import {
  SearchOutlined,
  ShoppingCartOutlined,
  UserOutlined,
} from "@ant-design/icons";
import useAuth from "../../hooks/useAuth";
import { Link } from "react-router-dom";

interface User {
  name: string;
}

interface Category {
  name: string;
  slug: string;
}

interface Props {
  user?: User | null;
  categories: Category[];
}

export default function Header({ user, categories }: Props) {
  const { logout } = useAuth();
  return (
    <header className={styles.header}>
      {/* TOP */}
      <div className={styles.top}>
        {/* LOGO */}
        <div className={styles.logo}>
          <Link to="/">
            <img src="/images/logo.png" alt="logo" />
          </Link>
        </div>

        {/* SEARCH */}
        <form
          className={styles.search}
          onSubmit={(e) => {
            e.preventDefault();
            const value = (e.currentTarget.q as any).value;
            window.location.href = `/search?q=${value}`;
          }}
        >
          <input name="q" placeholder="Tìm kiếm sản phẩm..." />
          <button type="submit">
            <SearchOutlined />
          </button>
        </form>

        {/* RIGHT */}
        <div className={styles.right}>
          <div className={styles.hotline}>
            <span>Hotline</span>
            <strong>0944 538 620</strong>
          </div>

          {user ? (
            <div className={styles.user}>
              <UserOutlined />
              <span>{user.name}</span>

              <div className={styles.dropdown}>
                <Link to="/profile">Tài khoản</Link>
                <Link to="/orders">Đơn hàng</Link>
                <span
                  onClick={(e) => {
                    e.preventDefault();
                    logout();
                  }}
                  className={styles.logout}
                  style={{ cursor: "pointer", display: "block" }}
                >
                  Đăng xuất
                </span>
              </div>
            </div>
          ) : (
            <Link to="/login" className={styles.login}>
              <UserOutlined />
            </Link>
          )}

          <Link to="/cart" className={styles.cart}>
            <ShoppingCartOutlined />
            <span>Giỏ hàng</span>
          </Link>
        </div>
      </div>

      {/* NAV */}
      <div className={styles.nav}>
        <div className={styles.categories}>
          <span>Danh mục</span>

          <div className={styles.dropdown}>
            {categories.map((c) => (
              <Link to={`/category/${c.slug}`} key={c.slug}>
                {c.name}
              </Link>
            ))}
          </div>
        </div>

        <Link to="/news">Tin tức</Link>
        <Link to="/store-system">Hệ thống cửa hàng</Link>

        <div className={styles.categories}>
          <span>Về chúng tôi</span>
          <div className={styles.dropdown}>
            <Link to="/introduce">Giới thiệu</Link>
            <Link to="/recruitment">Tuyển dụng</Link>
          </div>
        </div>
      </div>
    </header>
  );
}
