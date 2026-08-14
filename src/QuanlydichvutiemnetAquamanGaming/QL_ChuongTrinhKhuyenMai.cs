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
    public partial class QL_ChuongTrinhKhuyenMai : Form
    {
        string connectionString="Server=YOUR_SERVER;Database=AquamanGaming;Trusted_Connection=True;"

        public QL_ChuongTrinhKhuyenMai()
        {
            InitializeComponent();
        }

        private void QL_ChuongTrinhKhuyenMai_Load(object sender, EventArgs e)
        {
            txtTen.Clear();
            txtMoTa.Clear();
            txtDoiTuong.Clear();
            txtDieuKien.Clear();
            rdbNapTien.Checked = false;
            rdbDichVu.Checked = false;
            dtpTGTu.Value = new DateTime(1800, 1, 1);

            LoadData();
        }

        private void LoadData()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM KHUYENMAI ORDER BY MaKM";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dgvKhuyenMai.DataSource = dt;

                dgvKhuyenMai.Columns["MaKM"].ReadOnly = true; // KHÔNG cho sửa MaKM
            }
        }

        private void btnTimKiem_Click(object sender, EventArgs e)
        {
            string ten = txtTen.Text.Trim();
            string mota = txtMoTa.Text.Trim();
            string dt = txtDoiTuong.Text.Trim();
            string dk = txtDieuKien.Text.Trim();

            // Đọc loại KM từ radio
            string loai = "";
            if (rdbNapTien.Checked) loai = "Nạp tiền";
            else if (rdbDichVu.Checked) loai = "Dịch vụ ăn uống";

            DateTime fromDay = dtpTGTu.Value.Date;
            DateTime toDay = DateTime.Today;  // Tới thời điểm hiện tại

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string query =
                    "SELECT * FROM KHUYENMAI WHERE " +
                    "TenKM LIKE @ten AND " +
                    "MoTa LIKE @mota AND " +
                    "DoiTuong LIKE @dt AND " +
                    "DieuKien LIKE @dk AND " +
                    "(LoaiKM = @loai OR @loai = '') AND " +
                    "TGBatDau >= @fromDay AND " +
                    "TGKetThuc <= @toDay";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@ten", "%" + ten + "%");
                cmd.Parameters.AddWithValue("@mota", "%" + mota + "%");
                cmd.Parameters.AddWithValue("@dt", "%" + dt + "%");
                cmd.Parameters.AddWithValue("@dk", "%" + dk + "%");
                cmd.Parameters.AddWithValue("@loai", loai);  // Trống khi không chọn radio

                cmd.Parameters.AddWithValue("@fromDay", fromDay);
                cmd.Parameters.AddWithValue("@toDay", toDay);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dtResult = new DataTable();
                da.Fill(dtResult);

                dgvKhuyenMai.DataSource = dtResult;

                if (dtResult.Rows.Count == 0)
                {
                    MessageBox.Show("Không tìm thấy dữ liệu!", "Thông báo",
                        MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
            }
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            foreach (DataGridViewRow row in dgvKhuyenMai.Rows)
            {
                if (row.IsNewRow) continue;

                // Nếu MaKM rỗng => dòng mới cần thêm
                if (string.IsNullOrEmpty(row.Cells["MaKM"].Value?.ToString()))
                {
                    string ten = row.Cells["TenKM"].Value?.ToString()?.Trim();
                    string loai = row.Cells["LoaiKM"].Value?.ToString()?.Trim();
                    string mota = row.Cells["MoTa"].Value?.ToString()?.Trim();
                    string dt = row.Cells["DoiTuong"].Value?.ToString()?.Trim();
                    string dk = row.Cells["DieuKien"].Value?.ToString()?.Trim();

                    // Kiểm tra bắt buộc
                    if (string.IsNullOrEmpty(ten) || string.IsNullOrEmpty(loai))
                    {
                        MessageBox.Show("Tên KM và Loại KM là bắt buộc! Dòng này bị bỏ qua.",
                            "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        LoadData();
                        continue;
                    }

                    // Lấy TG bắt đầu + kết thúc
                    DateTime tgBD, tgKT;

                    if (!DateTime.TryParse(row.Cells["TGBatDau"].Value?.ToString(), out tgBD))
                        tgBD = DateTime.Today;

                    if (!DateTime.TryParse(row.Cells["TGKetThuc"].Value?.ToString(), out tgKT))
                        tgKT = DateTime.Today.AddMonths(1);

                    // Tạo mã mới
                    string ma = TaoMaKMAuto();

                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();
                        string query = @"INSERT INTO KHUYENMAI 
                                (MaKM, TenKM, LoaiKM, MoTa, DoiTuong, DieuKien, TGBatDau, TGKetThuc)
                                VALUES (@ma, @ten, @loai, @mota, @dt, @dk, @bd, @kt)";

                        SqlCommand cmd = new SqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@ma", ma);
                        cmd.Parameters.AddWithValue("@ten", ten);
                        cmd.Parameters.AddWithValue("@loai", loai);
                        cmd.Parameters.AddWithValue("@mota", mota ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@dt", dt ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@dk", dk ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@bd", tgBD);
                        cmd.Parameters.AddWithValue("@kt", tgKT);

                        cmd.ExecuteNonQuery();
                    }

                    MessageBox.Show("Thêm khuyến mãi mới thành công!", "Thông báo",
                        MessageBoxButtons.OK, MessageBoxIcon.Information);

                    LoadData(); // Refresh dgv
                    return; // Quan trọng: chỉ thêm 1 dòng
                }
            }
        }

        private string TaoMaKMAuto()
        {
            string ma = "KM001";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT TOP 1 MaKM FROM KHUYENMAI ORDER BY MaKM DESC";
                SqlCommand cmd = new SqlCommand(query, conn);

                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    string last = result.ToString().Substring(2);
                    int num = int.Parse(last) + 1;
                    ma = "KM" + num.ToString("D3");
                }
            }

            return ma;
        }

        private void btnSua_Click(object sender, EventArgs e)
        {
            foreach (DataGridViewRow row in dgvKhuyenMai.Rows)
            {
                if (row.IsNewRow) continue;

                string maKM = row.Cells["MaKM"].Value?.ToString();
                if (string.IsNullOrEmpty(maKM)) continue; // Bỏ qua dòng mới chưa có mã

                string ten = row.Cells["TenKM"].Value?.ToString()?.Trim();
                string loai = row.Cells["LoaiKM"].Value?.ToString()?.Trim();
                string mota = row.Cells["MoTa"].Value?.ToString()?.Trim();
                string doituong = row.Cells["DoiTuong"].Value?.ToString()?.Trim();
                string dieukien = row.Cells["DieuKien"].Value?.ToString()?.Trim();

                DateTime tgBD, tgKT;

                // Kiểm tra ngày bắt đầu
                if (!DateTime.TryParse(row.Cells["TGBatDau"].Value?.ToString(), out tgBD))
                {
                    MessageBox.Show($"Dòng MaKM = {maKM} bị bỏ qua vì TGBatDau không hợp lệ!",
                        "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    continue;
                }

                // Kiểm tra ngày kết thúc
                if (!DateTime.TryParse(row.Cells["TGKetThuc"].Value?.ToString(), out tgKT))
                {
                    MessageBox.Show($"Dòng MaKM = {maKM} bị bỏ qua vì TGKetThuc không hợp lệ!",
                        "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    continue;
                }

                // Kiểm tra ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu
                if (tgKT < tgBD)
                {
                    MessageBox.Show($"Dòng MaKM = {maKM}: TGKetThuc phải ≥ TGBatDau!",
                        "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    continue;
                }

                // Kiểm tra bắt buộc
                if (string.IsNullOrEmpty(ten) || string.IsNullOrEmpty(loai))
                {
                    MessageBox.Show($"Dòng MaKM = {maKM} bị bỏ qua vì thiếu Tên KM hoặc Loại KM!",
                        "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    continue;
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string query =
                        "UPDATE KHUYENMAI SET " +
                        "TenKM=@ten, LoaiKM=@loai, MoTa=@mota, DoiTuong=@doituong, DieuKien=@dieukien, " +
                        "TGBatDau=@tgBD, TGKetThuc=@tgKT " +
                        "WHERE MaKM=@ma";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@ten", ten);
                    cmd.Parameters.AddWithValue("@loai", loai);
                    cmd.Parameters.AddWithValue("@mota", mota);
                    cmd.Parameters.AddWithValue("@doituong", doituong);
                    cmd.Parameters.AddWithValue("@dieukien", dieukien);
                    cmd.Parameters.AddWithValue("@tgBD", tgBD);
                    cmd.Parameters.AddWithValue("@tgKT", tgKT);
                    cmd.Parameters.AddWithValue("@ma", maKM);

                    cmd.ExecuteNonQuery();
                }
            }

            MessageBox.Show("Đã sửa thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
            LoadData(); // Load lại dgv
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            if (dgvKhuyenMai.SelectedRows.Count == 0)
            {
                MessageBox.Show("Vui lòng chọn dòng để xóa!");
                return;
            }

            DialogResult dr = MessageBox.Show("Bạn chắc muốn xóa?", "Xác nhận", MessageBoxButtons.YesNo);
            if (dr == DialogResult.No) return;

            foreach (DataGridViewRow row in dgvKhuyenMai.SelectedRows)
            {
                string ma = row.Cells["MaKM"].Value?.ToString();
                if (string.IsNullOrEmpty(ma)) continue;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "DELETE FROM KHUYENMAI WHERE MaKM=@ma";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@ma", ma);
                    cmd.ExecuteNonQuery();
                }
            }

            MessageBox.Show("Xóa thành công!");
            LoadData();
        }

        private void btnHienThiTatCa_Click(object sender, EventArgs e)
        {
            txtTen.Clear();
            txtMoTa.Clear();
            txtDoiTuong.Clear();
            txtDieuKien.Clear();
            rdbNapTien.Checked = false;
            rdbDichVu.Checked = false;
            dtpTGTu.Value = new DateTime(1800, 1, 1);

            LoadData();
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
