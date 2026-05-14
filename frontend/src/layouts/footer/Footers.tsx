import {
  FacebookFilled,
  TwitterSquareFilled,
  YoutubeFilled,
  InstagramFilled,
  AmazonCircleFilled,
} from "@ant-design/icons";

import styles from "./footers.module.css";

export default function Footer() {
  return (
    <>
      <footer className={styles.footer}>
        <div className={styles.container}>
          <div className={styles.grid}>
            {/* LOGO + SOCIAL */}
            <div>
              <img src="/images/logo.png" alt="logo" className={styles.logo} />

              <p className={styles.description}>
                Cửa hàng thực phẩm tươi sạch, mang đến sản phẩm chất lượng mỗi
                ngày cho gia đình Việt.
              </p>

              <div className={styles.socials}>
                <a href="https://www.facebook.com/tdnbict" target="_blank">
                  <FacebookFilled />
                </a>

                <a href="https://www.facebook.com/tdnbict" target="_blank">
                  <TwitterSquareFilled />
                </a>

                <a href="https://www.facebook.com/tdnbict" target="_blank">
                  <YoutubeFilled />
                </a>

                <a href="https://www.facebook.com/tdnbict" target="_blank">
                  <InstagramFilled />
                </a>

                <a href="https://www.facebook.com/tdnbict" target="_blank">
                  <AmazonCircleFilled />
                </a>
              </div>
            </div>

            {/* CONTACT */}
            <div>
              <h3>Liên hệ</h3>

              <ul className={styles.menu}>
                <li>
                  <strong>Giờ làm việc:</strong> 6:00 - 21:00
                </li>

                <li>
                  <strong>Hotline:</strong> 0944538620
                </li>

                <li>
                  <strong>Email:</strong> trandiengtc@gmail.com
                </li>

                <li>
                  <strong>Địa chỉ:</strong> Xã Tứ Hiệp, Thanh Trì, Hà Nội
                </li>
              </ul>
            </div>

            {/* CATEGORY */}
            <div>
              <h3>Danh mục</h3>

              <ul className={styles.menu}>
                <li>
                  <a href="/introduce">Về chúng tôi</a>
                </li>

                <li>
                  <a href="/recruitment">Tuyển dụng</a>
                </li>
              </ul>
            </div>

            {/* SUPPORT */}
            <div>
              <h3>Hỗ trợ khách hàng</h3>

              <ul className={styles.menu}>
                <li>
                  <a href="/policy">Chính sách mua hàng</a>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </footer>

      {/* BOTTOM */}
      <div className={styles.bottom}>
        <div className={styles.container}>
          <div className={styles.bottomContent}>
            <p>© 2025 D-Food.</p>

            <p>Trần Văn Điền</p>
          </div>
        </div>
      </div>
    </>
  );
}
