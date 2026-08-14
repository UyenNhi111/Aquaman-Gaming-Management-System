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
    public partial class QL_DichVuAnUong : Form
    {
        string connectionString = @"Data Source=LAPTOP-FFG392QU;Initial Catalog=QLDVTN;Integrated Security=True";
        DataTable dtDichVu;

        public QL_DichVuAnUong()
        {
            InitializeComponent();
        }

        private void QL_DichVuAnUong_Load(object sender, EventArgs e)
        {
            LoadDichVu();
            LoadRandomDonHang();
        }

        private void LoadDichVu()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string sql = "SELECT * FROM DICHVUANUONG";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                dtDichVu = new DataTable();
                da.Fill(dtDichVu);
                dgvDichVu.DataSource = dtDichVu;

                // Khóa cột MaMon không cho sửa
                dgvDichVu.Columns["MaMon"].ReadOnly = true;
                dgvDichVu.Columns["MaNV"].ReadOnly = true;
            }
        }

        private void btnTimKiem_Click(object sender, EventArgs e)
        {
            string tenMon = txtTenMon.Text.Trim();
            string loaiMon = rdbDoAn.Checked ? "Đồ ăn" : rdbNuocUong.Checked ? "Nước uống" : "";
            string giaTien = txtGiaTien.Text.Trim();

            var query = dtDichVu.AsEnumerable();

            if (!string.IsNullOrEmpty(tenMon))
                query = query.Where(r => r.Field<string>("TenMon").IndexOf(tenMon, StringComparison.OrdinalIgnoreCase) >= 0);

            if (!string.IsNullOrEmpty(loaiMon))
                query = query.Where(r => r.Field<string>("LoaiMon").Trim() == loaiMon);

            if (decimal.TryParse(giaTien, out decimal gia))
                query = query.Where(r => r.Field<decimal>("DonGia") == gia);

            DataTable dtResult = query.Any() ? query.CopyToDataTable() : new DataTable();

            if (dtResult.Rows.Count == 0)
                MessageBox.Show("Không tìm thấy dữ liệu phù hợp!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);

            dgvDichVu.DataSource = dtResult;
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            int countThem = 0; // Đếm số dòng thêm thành công

            foreach (DataGridViewRow row in dgvDichVu.Rows)
            {
                if (row.IsNewRow) continue;

                // Nếu MaMon rỗng => dòng mới cần thêm
                if (string.IsNullOrEmpty(row.Cells["MaMon"].Value?.ToString()))
                {
                    string tenMon = row.Cells["TenMon"].Value?.ToString()?.Trim();
                    string loaiMon = row.Cells["LoaiMon"].Value?.ToString()?.Trim();
                    decimal donGia;

                    if (!decimal.TryParse(row.Cells["DonGia"].Value?.ToString(), out donGia))
                    {
                        MessageBox.Show("Giá tiền không hợp lệ! Dòng này sẽ bị bỏ qua.", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        LoadDichVu(); // Reload lại dgv để tránh lỗi
                        continue; // Bỏ qua dòng này
                    }

                    if (string.IsNullOrEmpty(tenMon) || string.IsNullOrEmpty(loaiMon))
                    {
                        MessageBox.Show("Tên món và Loại món là bắt buộc! Dòng này sẽ bị bỏ qua.", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        LoadDichVu(); // Reload lại dgv để tránh lỗi
                        continue;
                    }

                    string maMon = TaoMaMonTuDong(); // Hàm tạo mã tự động

                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();
                        string query = "INSERT INTO DICHVUANUONG (MaMon, TenMon, LoaiMon, DonGia, MaNV) " +
                                       "VALUES (@ma, @ten, @loai, @gia, @maNV)";
                        SqlCommand cmd = new SqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@ma", maMon);
                        cmd.Parameters.AddWithValue("@ten", tenMon);
                        cmd.Parameters.AddWithValue("@loai", loaiMon);
                        cmd.Parameters.AddWithValue("@gia", donGia);
                        cmd.Parameters.AddWithValue("@maNV", "NV004"); // Mặc định hoặc có thể lấy từ combo box nhân viên
                        cmd.ExecuteNonQuery();
                    }

                    countThem++;
                }
            }

            if (countThem > 0)
            {
                MessageBox.Show($"Đã thêm thành công {countThem} dòng!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                LoadDichVu(); // Reload lại dgv
            }
        }

        private void btnSua_Click(object sender, EventArgs e)
        {
            int countSua = 0; // Đếm số dòng sửa thành công

            foreach (DataGridViewRow row in dgvDichVu.Rows)
            {
                if (row.IsNewRow) continue;

                string maMon = row.Cells["MaMon"].Value?.ToString();
                if (string.IsNullOrEmpty(maMon)) continue; // Bỏ qua dòng mới chưa có MaMon

                string tenMon = row.Cells["TenMon"].Value?.ToString()?.Trim();
                string loaiMon = row.Cells["LoaiMon"].Value?.ToString()?.Trim();
                decimal donGia;

                if (!decimal.TryParse(row.Cells["DonGia"].Value?.ToString(), out donGia))
                {
                    MessageBox.Show($"Dòng MaMon={maMon} bị bỏ qua vì Giá tiền không hợp lệ!", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    continue;
                }

                if (string.IsNullOrEmpty(tenMon) || string.IsNullOrEmpty(loaiMon))
                {
                    MessageBox.Show($"Dòng MaMon={maMon} bị bỏ qua vì thiếu Tên món hoặc Loại món!", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    continue;
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "UPDATE DICHVUANUONG SET TenMon=@ten, LoaiMon=@loai, DonGia=@gia WHERE MaMon=@ma";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@ten", tenMon);
                    cmd.Parameters.AddWithValue("@loai", loaiMon);
                    cmd.Parameters.AddWithValue("@gia", donGia);
                    cmd.Parameters.AddWithValue("@ma", maMon);

                    int result = cmd.ExecuteNonQuery();
                    if (result > 0) countSua++;
                }
            }

            if (countSua > 0)
            {
                MessageBox.Show($"Đã sửa thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                LoadDichVu(); // Reload lại dgvDichVu
            }
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            if (dgvDichVu.SelectedRows.Count == 0)
            {
                MessageBox.Show("Vui lòng chọn dòng để xóa!", "Thông báo");
                return;
            }

            DialogResult dr = MessageBox.Show("Bạn có chắc chắn muốn xóa?", "Xác nhận", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (dr == DialogResult.No) return;

            foreach (DataGridViewRow row in dgvDichVu.SelectedRows)
            {
                string maMon = row.Cells["MaMon"].Value?.ToString();
                if (string.IsNullOrEmpty(maMon)) continue;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "DELETE FROM DICHVUANUONG WHERE MaMon=@ma";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@ma", maMon);
                    cmd.ExecuteNonQuery();
                }
            }

            MessageBox.Show("Xóa thành công!", "Thông báo");
            LoadDichVu(); // Reload lại dgvDichVu
        }

        private void LoadRandomDonHang()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Lấy 1 MaHDDV ngẫu nhiên
                string sqlRandomHDDV = "SELECT TOP 1 MaHDDV FROM HOADONDICHVU ORDER BY NEWID()";
                SqlCommand cmd = new SqlCommand(sqlRandomHDDV, conn);
                string maHDDV = cmd.ExecuteScalar()?.ToString();

                if (string.IsNullOrEmpty(maHDDV))
                {
                    txtDonHang.Text = "Chưa có đơn hàng nào.";
                    return;
                }

                // Lấy chi tiết các món trong đơn
                string sqlChiTiet = @"
                SELECT d.TenMon, c.SoLuong, c.DonGia, h.KhuyenMaiDV, 
                   (c.SoLuong * c.DonGia - ISNULL(h.KhuyenMaiDV,0)) AS ThanhTien
                FROM CTHOADONDICHVU c
                JOIN DICHVUANUONG d ON c.MaMon = d.MaMon
                JOIN HOADONDICHVU h ON c.MaHDDV = h.MaHDDV
                WHERE h.MaHDDV = @MaHDDV";
                SqlDataAdapter da = new SqlDataAdapter(sqlChiTiet, conn);
                da.SelectCommand.Parameters.AddWithValue("@MaHDDV", maHDDV);

                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count == 0)
                {
                    txtDonHang.Text = "Đơn hàng trống.";
                    return;
                }

                // Hiển thị trong TextBox
                StringBuilder sb = new StringBuilder();
                sb.AppendLine($"Đơn hàng: {maHDDV}");
                sb.AppendLine("Tên món           SL     ĐG              KM                  Thành tiền");
                sb.AppendLine("--------------------------------------------------------------------------------------");

                foreach (DataRow row in dt.Rows)
                {
                    sb.AppendLine($"{row["TenMon"],-18} {row["SoLuong"],-3} {row["DonGia"],-10} {row["KhuyenMaiDV"],-10} {row["ThanhTien"],-10}");
                }

                txtDonHang.Text = sb.ToString();
            }
        }

        private void btnXacNhan_Click(object sender, EventArgs e)
        {
            DialogResult dr = MessageBox.Show("Bạn có muốn in hóa đơn không?", "Xác nhận đơn hàng", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Question);
            if (dr == DialogResult.Yes)
            {
                txtDonHang.Clear();
                MessageBox.Show("Hóa đơn đã in!", "Thông báo");
            }
            else if (dr == DialogResult.No)
            {
                txtDonHang.Clear();
                LoadRandomDonHang();
            }
        }

        private void btnHoanThanh_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Xác nhận hoàn thành đơn hàng?", "Hoàn thành", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                txtDonHang.Clear();
                LoadRandomDonHang();
            }
        }

        private void btnQuayLai_Click(object sender, EventArgs e)
        {
            TrangChu f = new TrangChu();
            this.Hide();
            f.ShowDialog();
            this.Close();
        }

        private void btnHienThiTatCa_Click(object sender, EventArgs e)
        {
            txtTenMon.Clear();
            txtGiaTien.Clear();
            rdbDoAn.Checked = false;
            rdbNuocUong.Checked = false;

            LoadDichVu();
        }

        private string TaoMaMonTuDong()
        {
            int maxId = 0;
            foreach (DataRow row in dtDichVu.Rows)
            {
                string ma = row["MaMon"].ToString().Replace("MA", "");
                if (int.TryParse(ma, out int num))
                {
                    if (num > maxId) maxId = num;
                }
            }
            return "MA" + (maxId + 1).ToString("000");
        }
    }
}
