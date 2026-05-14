import styles from './loading.module.css';

export default function Loading(props: any) {
  const { isOverlay = true, size, isLight } = props;

  return (
    <div
      className={`${isOverlay ? styles.overlay : ''} 
       ${isLight ? styles.light : ''} ${size == 'small' ? styles.small : ''}`}
    >
      <div>
        <div className={styles.loader}></div>
      </div>
    </div>
  );
}
