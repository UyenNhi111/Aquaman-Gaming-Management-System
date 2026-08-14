using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace QuanlydichvutiemnetAquamanGaming
{
    public partial class QL_DangKyTaiKhoan : Form
    {
        private string connectionString = @"Data Source=LAPTOP-FFG392QU;Initial Catalog=QLDVTN;Integrated Security=True";

        private decimal oldSoDu = 0;

        public QL_DangKyTaiKhoan()
        {
            InitializeComponent();
            // Ban đầu ẩn cả hai panel, hoặc tuỳ theo UI bạn muốn
            panelCreate.Visible = false;
            panelSearch.Visible = false;

            // load tất cả tài khoản vào DataGridView
            LoadData();
        }

        #region UI - show panels
        private void btnTaoThuong_Click(object sender, EventArgs e)
        {
            panelCreate.Visible = true;
            // chế độ tạo thường: cho phép thay đổi tên đăng nhập
            txtUserNameCreate.ReadOnly = false;
            ClearCreateFields();
        }

        private void btnTaoMotLan_Click(object sender, EventArgs e)
        {
            panelCreate.Visible = true;
            // tên đăng nhập 10 số 0 và không cho sửa
            ClearCreateFields();
            txtUserNameCreate.Text = "0000000000";
            txtUserNameCreate.ReadOnly = true;
        }

        private void btnTimKiemTK_Click(object sender, EventArgs e)
        {
            panelSearch.Visible = true;
        }
        #endregion

        #region Load / Refresh
        private void LoadData()
        {
            using (SqlConnection cn = new SqlConnection(connectionString))
            {
                string sql = "SELECT MaTK, TenDangNhap, MatKhau, SoDu, LoaiTK, TrangThaiTK, MaND FROM TAIKHOAN ORDER BY MaTK";
                using (SqlDataAdapter da = new SqlDataAdapter(sql, cn))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dgvTaiKhoan.DataSource = dt;
                }
            }
        }
        #endregion

        #region Create account
        private void btnTao_Click(object sender, EventArgs e)
        {
            // Validate
            if (string.IsNullOrWhiteSpace(txtUserNameCreate.Text))
            {
                MessageBox.Show("Vui lòng điền tên đăng nhập.", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            if (string.IsNullOrWhiteSpace(txtPasswordCreate.Text))
            {
                MessageBox.Show("Vui lòng nhập mật khẩu.", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            if (string.IsNullOrWhiteSpace(txtRePasswordCreate.Text))
            {
                MessageBox.Show("Vui lòng nhập lại mật khẩu.", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            if (txtPasswordCreate.Text != txtRePasswordCreate.Text)
            {
                MessageBox.Show("Mật khẩu và nhập lại mật khẩu không khớp.", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            string tenDN = txtUserNameCreate.Text.Trim();
            string matKhau = txtPasswordCreate.Text.Trim();
            string loaiTK;
            string trangThai = "Hoạt động"; // theo yêu cầu: khi kích hoạt tạo thành công -> trạng thái Hoạt động
            string maND = null; // theo yêu cầu: tạm thời khi tạo 1 lần MaND = NULL ; với tài khoản thường bạn có thể để NULL hoặc tuỳ UI cho nhập MaND

            // if username = '0000000000' thì đảm bảo loại là Tạm thời nếu ko thì Thường
            if (tenDN == "0000000000") loaiTK = "Tạm thời";
            else loaiTK = "Thường";

            // Tạo MaTK tự động tăng theo csdl sẵn (format TK + 6 chữ số)
            string newMaTK = GenerateNextMaTK();

            // SoDu mặc định 0 khi tạo mới
            decimal soDu = 0m;

            using (SqlConnection cn = new SqlConnection(connectionString))
            {
                cn.Open();
                string insert = @"INSERT INTO TAIKHOAN (MaTK, TenDangNhap, MatKhau, SoDu, LoaiTK, TrangThaiTK, MaND)
                              VALUES (@MaTK, @TenDN, @MatKhau, @SoDu, @LoaiTK, @TrangThaiTK, @MaND)";
                using (SqlCommand cmd = new SqlCommand(insert, cn))
                {
                    cmd.Parameters.AddWithValue("@MaTK", newMaTK);
                    cmd.Parameters.AddWithValue("@TenDN", tenDN);
                    cmd.Parameters.AddWithValue("@MatKhau", matKhau);
                    cmd.Parameters.AddWithValue("@SoDu", soDu);
                    cmd.Parameters.AddWithValue("@LoaiTK", loaiTK);
                    cmd.Parameters.AddWithValue("@TrangThaiTK", trangThai);
                    if (string.IsNullOrWhiteSpace(maND))
                        cmd.Parameters.AddWithValue("@MaND", DBNull.Value);
                    else
                        cmd.Parameters.AddWithValue("@MaND", maND);

                    try
                    {
                        cmd.ExecuteNonQuery();
                        MessageBox.Show("Tạo tài khoản thành công.\nMã TK: " + newMaTK, "Thành công", MessageBoxButtons.OK, MessageBoxIcon.Information);
                        ClearCreateFields();
                        LoadData();
                    }
                    catch (SqlException ex)
                    {
                        MessageBox.Show("Lỗi khi tạo tài khoản: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
        }

        private string GenerateNextMaTK()
        {
            // Giả sử format MaTK = 'TK' + 6 chữ số (vd TK000001)
            using (SqlConnection cn = new SqlConnection(connectionString))
            {
                cn.Open();
                string sql = "SELECT MAX(MaTK) FROM TAIKHOAN";
                using (SqlCommand cmd = new SqlCommand(sql, cn))
                {
                    var obj = cmd.ExecuteScalar();
                    if (obj == DBNull.Value || obj == null)
                    {
                        return "TK000001";
                    }
                    else
                    {
                        string maxMa = obj.ToString(); // VD TK000020
                                                       // Lấy phần số
                        string digits = "";
                        for (int i = 0; i < maxMa.Length; i++)
                            if (char.IsDigit(maxMa[i])) digits += maxMa[i];

                        if (!int.TryParse(digits, out int n))
                        {
                            // fallback
                            n = 0;
                        }
                        n++;
                        return "TK" + n.ToString("D6");
                    }
                }
            }
        }

        private void ClearCreateFields()
        {
            txtUserNameCreate.Text = "";
            txtPasswordCreate.Text = "";
            txtRePasswordCreate.Text = "";
            txtUserNameCreate.ReadOnly = false;
        }
        #endregion

        #region Lock / Delete account (operate on selected row in dgv)
        private void btnKichHoat_Click(object sender, EventArgs e)
        {
            if (dgvTaiKhoan.CurrentRow == null)
            {
                MessageBox.Show("Vui lòng chọn tài khoản trong bảng để kích hoạt.", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            string maTK = dgvTaiKhoan.CurrentRow.Cells["MaTK"].Value.ToString();
            UpdateTrangThai(maTK, "Hoạt động", null); // chỉ đổi trạng thái
            LoadData();
        }

        private void btnKhoaTK_Click(object sender, EventArgs e)
        {
            if (dgvTaiKhoan.CurrentRow == null)
            {
                MessageBox.Show("Vui lòng chọn tài khoản trong bảng để khóa.", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            string maTK = dgvTaiKhoan.CurrentRow.Cells["MaTK"].Value.ToString();
            UpdateTrangThai(maTK, "Khóa", null); // chỉ đổi trạng thái
            LoadData();
        }

        private void btnXoaTK_Click(object sender, EventArgs e)
        {
            if (dgvTaiKhoan.CurrentRow == null)
            {
                MessageBox.Show("Vui lòng chọn tài khoản trong bảng để xóa.", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            string maTK = dgvTaiKhoan.CurrentRow.Cells["MaTK"].Value.ToString();
            // khi xóa: trạng thái thành 'Đã xóa' và số dư = 0
            UpdateTrangThai(maTK, "Đã xóa", 0m);
            LoadData();
        }

        private void UpdateTrangThai(string maTK, string trangThai, decimal? setSoDu)
        {
            using (SqlConnection cn = new SqlConnection(connectionString))
            {
                cn.Open();
                string sql = "UPDATE TAIKHOAN SET TrangThaiTK = @TrangThai";
                if (setSoDu.HasValue)
                    sql += ", SoDu = @SoDu";
                sql += " WHERE MaTK = @MaTK";

                using (SqlCommand cmd = new SqlCommand(sql, cn))
                {
                    cmd.Parameters.AddWithValue("@TrangThai", trangThai);
                    if (setSoDu.HasValue) cmd.Parameters.AddWithValue("@SoDu", setSoDu.Value);
                    cmd.Parameters.AddWithValue("@MaTK", maTK);
                    try
                    {
                        cmd.ExecuteNonQuery();
                        MessageBox.Show("Cập nhật trạng thái thành công.", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                    catch (SqlException ex)
                    {
                        MessageBox.Show("Lỗi khi cập nhật trạng thái: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
        }
        #endregion

        #region Search panel
        private void btnSearch_Click(object sender, EventArgs e)
        {
            // Tìm theo 4 tiêu chí: TenDangNhap (partial), LoaiTK (radio), TrangThaiTK (radio), MaND (partial)
            string tenDNpart = txtSearchUserName.Text.Trim();
            string maNDpart = txtMaNDSearch.Text.Trim();

            string loaiTK = null;
            if (rbLoaiThuong.Checked) loaiTK = "Thường";
            else if (rbLoaiTam.Checked) loaiTK = "Tạm thời";

            string trangThai = null;
            if (rbTT_HoatDong.Checked) trangThai = "Hoạt động";
            else if (rbTT_Khoa.Checked) trangThai = "Khóa";
            else if (rbTT_ChuaKichHoat.Checked) trangThai = "Chưa kích hoạt";
            else if (rbTT_DaXoa.Checked) trangThai = "Đã xóa";

            using (SqlConnection cn = new SqlConnection(connectionString))
            {
                cn.Open();
                // Build dynamic WHERE with parameters to allow partial matching
                string sql = "SELECT MaTK, TenDangNhap, MatKhau, SoDu, LoaiTK, TrangThaiTK, MaND FROM TAIKHOAN WHERE 1=1";
                if (!string.IsNullOrEmpty(tenDNpart))
                {
                    sql += " AND TenDangNhap LIKE @TenDN";
                }
                if (!string.IsNullOrEmpty(loaiTK))
                {
                    sql += " AND LoaiTK = @LoaiTK";
                }
                if (!string.IsNullOrEmpty(trangThai))
                {
                    sql += " AND TrangThaiTK = @TrangThai";
                }
                if (!string.IsNullOrEmpty(maNDpart))
                {
                    sql += " AND MaND LIKE @MaND";
                }
                using (SqlCommand cmd = new SqlCommand(sql, cn))
                {
                    if (!string.IsNullOrEmpty(tenDNpart))
                        cmd.Parameters.AddWithValue("@TenDN", "%" + tenDNpart + "%");
                    if (!string.IsNullOrEmpty(loaiTK))
                        cmd.Parameters.AddWithValue("@LoaiTK", loaiTK);
                    if (!string.IsNullOrEmpty(trangThai))
                        cmd.Parameters.AddWithValue("@TrangThai", trangThai);
                    if (!string.IsNullOrEmpty(maNDpart))
                        cmd.Parameters.AddWithValue("@MaND", "%" + maNDpart + "%");

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        dgvTaiKhoan.DataSource = dt;
                    }
                }
            }
        }
        #endregion

        private void btnShowAll_Click(object sender, EventArgs e)
        {
            // Reset filters and show all
            txtSearchUserName.Text = "";
            txtMaNDSearch.Text = "";
            rbLoaiThuong.Checked = false;
            rbLoaiTam.Checked = false;
            rbTT_HoatDong.Checked = false;
            rbTT_Khoa.Checked = false;
            rbTT_ChuaKichHoat.Checked = false;
            rbTT_DaXoa.Checked = false;

            LoadData();
        }

        private void btnBack_Click(object sender, EventArgs e)
        {
            TrangChu f = new TrangChu();
            this.Hide();
            f.ShowDialog();
            this.Close();
        }

        private void dgvTaiKhoan_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvTaiKhoan.Columns[e.ColumnIndex].Name == "SoDu")
            {
                oldSoDu = Convert.ToDecimal(dgvTaiKhoan.Rows[e.RowIndex].Cells["SoDu"].Value);
            }
        }

        private void dgvTaiKhoan_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            if (dgvTaiKhoan.Columns[e.ColumnIndex].Name != "SoDu") return;

            string maTK = dgvTaiKhoan.Rows[e.RowIndex].Cells["MaTK"].Value.ToString();
            decimal newSoDu;

            if (!decimal.TryParse(dgvTaiKhoan.Rows[e.RowIndex].Cells["SoDu"].Value.ToString(), out newSoDu))
            {
                MessageBox.Show("Số dư không hợp lệ!", "Lỗi");
                dgvTaiKhoan.Rows[e.RowIndex].Cells["SoDu"].Value = oldSoDu;
                return;
            }

            if (newSoDu - oldSoDu < 5000)
            {
                MessageBox.Show("Số dư mới phải lớn hơn số dư cũ ÍT NHẤT 5000!", "Lỗi");
                dgvTaiKhoan.Rows[e.RowIndex].Cells["SoDu"].Value = oldSoDu;
                return;
            }

            // Chọn hình thức nạp tiền
            string hinhThuc = Ask_HinhThucNap();

            if (hinhThuc == "Hủy")
            {
                dgvTaiKhoan.Rows[e.RowIndex].Cells["SoDu"].Value = oldSoDu;
                return;
            }

            // UPDATE số dư vào DB
            UpdateSoDu(maTK, newSoDu);

            // Chuyển sang form Hóa đơn nạp tiền
            decimal soTienNap = newSoDu - oldSoDu;

            QL_HoaDonNapTien h = new QL_HoaDonNapTien(soTienNap, hinhThuc);
            h.ShowDialog();
            this.Hide();
            LoadData();
            this.Close();
        }

        private string Ask_HinhThucNap()
        {
            DialogResult r = MessageBox.Show(
                "Chọn hình thức nạp tiền:\n\nYES = Tiền mặt\nNO = Chuyển khoản\nCANCEL = Hủy",
                "Xác nhận",
                MessageBoxButtons.YesNoCancel,
                MessageBoxIcon.Question);

            if (r == DialogResult.Yes) return "Tiền mặt";
            if (r == DialogResult.No) return "Chuyển khoản";
            return "Hủy";
        }

        private void UpdateSoDu(string maTK, decimal soDu)
        {
            using (SqlConnection cn = new SqlConnection(connectionString))
            {
                cn.Open();
                string sql = "UPDATE TAIKHOAN SET SoDu = @SoDu WHERE MaTK = @MaTK";
                SqlCommand cmd = new SqlCommand(sql, cn);
                cmd.Parameters.AddWithValue("@SoDu", soDu);
                cmd.Parameters.AddWithValue("@MaTK", maTK);
                cmd.ExecuteNonQuery();
            }
        }

        private void QL_DangKyTaiKhoan_Load(object sender, EventArgs e)
        {
            dgvTaiKhoan.Columns["SoDu"].ReadOnly = false;
            dgvTaiKhoan.Columns["MaTK"].ReadOnly =
            dgvTaiKhoan.Columns["TenDangNhap"].ReadOnly =
            dgvTaiKhoan.Columns["MatKhau"].ReadOnly =
            dgvTaiKhoan.Columns["LoaiTK"].ReadOnly =
            dgvTaiKhoan.Columns["TrangThaiTK"].ReadOnly =
            dgvTaiKhoan.Columns["MaND"].ReadOnly = true;
        }
    }
}
