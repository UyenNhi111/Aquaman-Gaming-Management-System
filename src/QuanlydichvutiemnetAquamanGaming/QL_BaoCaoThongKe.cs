using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuanlydichvutiemnetAquamanGaming
{
    public partial class QL_BaoCaoThongKe : Form
    {
        string connectionString="Server=YOUR_SERVER;Database=AquamanGaming;Trusted_Connection=True;"

        public QL_BaoCaoThongKe()
        {
            InitializeComponent();
        }

        private object ExecScalar(string query)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(query, conn);
                return cmd.ExecuteScalar();
            }
        }

        private void LoadGrid(string query)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dgvBaoCao.DataSource = dt;
            }
        }

        private void btnBaoCaoDoanhThuMay_Click(object sender, EventArgs e)
        {
            string queryGrid =
            @"SELECT ND.MaND, ND.HoTen, TTSUDUNG.MaMay,
            TTSUDUNG.GioBatDau, TTSUDUNG.GioKetThuc, TTSUDUNG.SoTienTru
            FROM TTSUDUNG
            JOIN NGUOIDUNG ND ON ND.MaND = TTSUDUNG.MaND";
            LoadGrid(queryGrid);

            string querySum = "SELECT SUM(SoTienTru) FROM TTSUDUNG";
            object total = ExecScalar(querySum);
            txtKetQua.Text = "BÁO CÁO DOANH THU PHÒNG MÁY\n\n";
            txtKetQua.Text += $"Tổng doanh thu phòng máy: {total} đ";
        }

        private void btnBaoCaoDoanhThuDV_Click(object sender, EventArgs e)
        {
            string queryGrid =
            @"SELECT H.MaHDDV, H.ThoiGianDat, H.TongTien,
            ND.HoTen AS NguoiDung, NV.HoTen AS NhanVien
            FROM HOADONDICHVU H
            LEFT JOIN NGUOIDUNG ND ON ND.MaND = H.MaND
            LEFT JOIN NHANVIEN NV ON NV.MaNV = H.MaNV";
            LoadGrid(queryGrid);

            string querySum = "SELECT SUM(TongTien) FROM HOADONDICHVU";
            object total = ExecScalar(querySum);
            txtKetQua.Text = "BÁO CÁO DOANH THU DỊCH VỤ ĂN UỐNG\n\n";
            txtKetQua.Text += $"Tổng doanh thu dịch vụ ăn uống: {total} đ";
        }

        private void btnBaoCaoSuCo_Click(object sender, EventArgs e)
        {
            string queryGrid =
            @"SELECT S.MaKT, S.TGYeuCau, S.MoTaVanDe, S.TrangThaiSC,
            NV.HoTen AS NhanVien, M.MaMay, ND.HoTen AS NguoiDung
            FROM SUCOKYTHUAT S
            LEFT JOIN NHANVIEN NV ON NV.MaNV = S.MaNV
            LEFT JOIN MAYTINH M ON M.MaMay = S.MaMay
            LEFT JOIN NGUOIDUNG ND ON ND.MaND = S.MaND";
            LoadGrid(queryGrid);

            int soSuCo = Convert.ToInt32(ExecScalar("SELECT COUNT(*) FROM SUCOKYTHUAT"));

            int soLanSD = Convert.ToInt32(ExecScalar("SELECT COUNT(*) FROM TTSUDUNG"));

            double tile = 0;
            if (soLanSD > 0)
                tile = (double)soSuCo / soLanSD * 100;

            txtKetQua.Text = "BÁO CÁO SỰ CỐ KỸ THUẬT\n\n";
            txtKetQua.Text +=
                $"Tổng số sự cố: {soSuCo}\r\n" +
                $"Tổng số lần sử dụng máy: {soLanSD}\r\n" +
                $"Tỷ lệ sự cố: {tile:F2}%";
        }

        private void btnBaoCaoNguoiDung_Click(object sender, EventArgs e)
        {
            string queryGrid =
            @"SELECT ND.MaND, ND.HoTen, ND.GioiTinh, ND.NgaySinh,
            ND.SDT, TK.SoDu, TK.TrangThaiTK
            FROM NGUOIDUNG ND
            LEFT JOIN TAIKHOAN TK ON TK.MaND = ND.MaND";
            LoadGrid(queryGrid);

            int tongND = Convert.ToInt32(ExecScalar("SELECT COUNT(*) FROM NGUOIDUNG"));

            int hoatDong = Convert.ToInt32(
            ExecScalar("SELECT COUNT(*) FROM TAIKHOAN WHERE TrangThaiTK = N'Hoạt động'")
            );

            txtKetQua.Text = "BÁO CÁO NGƯỜI DÙNG\n\n";
            txtKetQua.Text +=
                $"Tổng số người dùng: {tongND}\r\n" +
                $"Số tài khoản hoạt động: {hoatDong}";
        }

        private void btnBaoCaoTinhTrangMay_Click(object sender, EventArgs e)
        {
            LoadGrid("SELECT MaMay, LoaiMay, TrangThaiMay, GhiChu FROM MAYTINH");

            int tongMay = Convert.ToInt32(ExecScalar("SELECT COUNT(*) FROM MAYTINH"));

            int baoTri = Convert.ToInt32(
            ExecScalar("SELECT COUNT(*) FROM MAYTINH WHERE TrangThaiMay = N'Bảo trì'")
            );

            int dangDung = Convert.ToInt32(
            ExecScalar("SELECT COUNT(*) FROM MAYTINH WHERE TrangThaiMay = N'Đang dùng'")
            );

            double tile = tongMay > 0 ? (double)dangDung / tongMay * 100 : 0;

            txtKetQua.Text = "BÁO CÁO TÌNH TRẠNG PHÒNG MÁY\n\n";
            txtKetQua.Text +=
                $"Tổng số máy: {tongMay}\r\n" +
                $"Máy đang bảo trì: {baoTri}\r\n" +
                $"Máy đang sử dụng: {dangDung}\r\n" +
                $"Tỷ lệ sử dụng: {tile:F2}%";

        }

        private void btnQuayLai_Click(object sender, EventArgs e)
        {
            TrangChu f = new TrangChu();
            this.Hide();
            f.ShowDialog();
            this.Close();
        }
    }
}
