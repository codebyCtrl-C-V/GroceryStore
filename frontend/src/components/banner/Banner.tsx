import styles from "./banner.module.css";
import { ArrowRightOutlined } from "@ant-design/icons";
import { Carousel } from "antd";

export default function Banner() {
  return (
    <section
      className={styles.bannerSection}
      style={{
        backgroundImage: "url('/images/background-pattern.jpg')",
      }}
    >
      <div className={styles.container}>
        <div className={styles.grid}>
          {/* MAIN SLIDER */}
          <div className={`${styles.bannerCard} ${styles.mainBanner}`}>
            <Carousel autoplay dots>
              {/* SLIDE 1 */}
              <div>
                <div className={styles.slide}>
                  <div className={styles.content}>
                    <span className={styles.category}>
                      100% Tự nhiên
                    </span>

                    <h2>Nước cam tươi</h2>

                    <p>
                      Sản phẩm được ưu chuộng nhất hiện nay,
                      có hương vị ngọt thanh pha chút chua nhẹ,
                      giàu vitamin C và khoáng chất.
                    </p>

                    <a href="/product/nuoc-cam" className={styles.button}>
                      Mua ngay
                    </a>
                  </div>

                  <div className={styles.imageWrapper}>
                    <img
                      src="https://res.cloudinary.com/dilsgqfex/image/upload/t_nc1/v1741275375/n%C6%B0%E1%BB%9Bc_cam_ev4s7h.png"
                      alt="Nước cam"
                    />
                  </div>
                </div>
              </div>

              {/* SLIDE 2 */}
              <div>
                <div className={styles.slide}>
                  <div className={styles.content}>
                    <span className={styles.category}>
                      Nhập khẩu chính hãng
                    </span>

                    <h2>Nho đen không hạt</h2>

                    <p>
                      Trái cây nhập khẩu cao cấp,
                      giàu vitamin và chất chống oxy hóa,
                      giúp tăng cường sức khỏe.
                    </p>

                    <a href="/product/nho" className={styles.button}>
                      Mua ngay
                    </a>
                  </div>

                  <div className={styles.imageWrapper}>
                    <img
                      src="https://res.cloudinary.com/dilsgqfex/image/upload/v1741277416/nho_aazmxu.png"
                      alt="Nho"
                    />
                  </div>
                </div>
              </div>
            </Carousel>
          </div>

          {/* SMALL BANNER 1 */}
          <div
            className={`${styles.bannerCard} ${styles.smallBanner}`}
            style={{
              backgroundImage:
                "url('https://res.cloudinary.com/dilsgqfex/image/upload/v1741278084/ad-image-1_qo1xt4.png')",
            }}
          >
            <div className={styles.smallContent}>
              <span className={styles.sale}>15-20% OFF</span>

              <h3>Trái cây & Rau củ</h3>

              <a href="/category/sale/vegetables-fruits?page=1">
                Đến xem <ArrowRightOutlined />
              </a>
            </div>
          </div>

          {/* SMALL BANNER 2 */}
          <div
            className={`${styles.bannerCard} ${styles.smallBanner}`}
            style={{
              backgroundImage:
                "url('https://res.cloudinary.com/dilsgqfex/image/upload/v1741445162/salad_rau_c%E1%BB%A7_sag138.png')",
            }}
          >
            <div className={styles.smallContent}>
              <span className={styles.sale}>15-20% OFF</span>

              <h3>Sản phẩm chế biến</h3>

              <a href="/category/sale/proceed?page=1">
                Đến xem <ArrowRightOutlined />
              </a>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}