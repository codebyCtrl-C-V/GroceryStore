import styles from "./mainHeader.module.css";
import {
  SearchOutlined,
  ShoppingCartOutlined,
  UserOutlined,
} from "@ant-design/icons";

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
  return (
    <header className={styles.header}>
      {/* TOP */}
      <div className={styles.top}>
        {/* LOGO */}
        <div className={styles.logo}>
          <a href="/">
            <img src="/images/logo.png" alt="logo" />
          </a>
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
                <a href="/profile">Tài khoản</a>
                <a href="/orders">Đơn hàng</a>
                <a href="/logout" className={styles.logout}>
                  Đăng xuất
                </a>
              </div>
            </div>
          ) : (
            <a href="/login" className={styles.login}>
              <UserOutlined />
            </a>
          )}

          <a href="/cart" className={styles.cart}>
            <ShoppingCartOutlined />
            <span>Giỏ hàng</span>
          </a>
        </div>
      </div>

      {/* NAV */}
      <div className={styles.nav}>
        <div className={styles.categories}>
          <span>Danh mục</span>

          <div className={styles.dropdown}>
            {categories.map((c) => (
              <a key={c.slug} href={`/category/${c.slug}`}>
                {c.name}
              </a>
            ))}
          </div>
        </div>

        <a href="/news">Tin tức</a>
        <a href="/store-system">Hệ thống cửa hàng</a>

        <div className={styles.categories}>
          <span>Về chúng tôi</span>
          <div className={styles.dropdown}>
            <a href="/introduce">Giới thiệu</a>
            <a href="/recruitment">Tuyển dụng</a>
          </div>
        </div>
      </div>
    </header>
  );
}
