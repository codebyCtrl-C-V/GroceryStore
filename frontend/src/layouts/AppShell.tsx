import { Outlet } from "react-router-dom";

// Layout wrapper tránh unmount trắng màn hình web
export default function AppShell() {
  return (
    <div
      style={{
        minHeight: "100vh",
        backgroundColor: "#fff", 
      }}
    >
      <Outlet /> 
    </div>
  );
}