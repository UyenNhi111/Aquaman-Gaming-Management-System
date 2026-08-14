--DROP TABLE IF EXISTS ct_hoadondichvu;
--DROP TABLE IF EXISTS tt_sudung;
--DROP TABLE IF EXISTS hoadondichvu;
--DROP TABLE IF EXISTS hoadonnaptien;
--DROP TABLE IF EXISTS sucokythuat;
--DROP TABLE IF EXISTS taikhoannhanvien;
--DROP TABLE IF EXISTS taikhoan;
--DROP TABLE IF EXISTS dichvuanuong;
--DROP TABLE IF EXISTS khuyenmai;
--DROP TABLE IF EXISTS maytinh;
--DROP TABLE IF EXISTS nhanvien;
--DROP TABLE IF EXISTS nguoidung;
--go


---------------------------------------------------
---- Cấu trúc bảng
---------------------------------------------------


--CREATE TABLE nguoidung (
--    nguoidung_id CHAR(10) CONSTRAINT pk_nguoidung PRIMARY KEY,-- Mã người dùng theo cấu trúc NDxxxxxx
--    ho_ten NVARCHAR(100) NULL,-- Họ và tên người dùng
--    gioi_tinh NVARCHAR(5) NULL,-- Giới tính người dùng là "Nam" hoặc "Nữ"
--    ngay_sinh DATE NULL,-- Ngày sinh của người dùng
--    sdt NVARCHAR(15) NOT NULL UNIQUE,-- Số điện thoại người dùng
--)

--CREATE TABLE taikhoan (
--    TK_id CHAR(10) CONSTRAINT pk_taikhoan PRIMARY KEY,-- Mã có cấu trúc TKxxxxxx
--    ten_dang_nhap NVARCHAR(15) NOT NULL,-- Tên đăng nhập là số điện thoại người dùng hoặc là 10 số 0 nếu là tài khoản tạm thời
--    mat_khau NVARCHAR(20) NOT NULL, -- Mật khẩu tài khoản
--    so_du DECIMAL(10, 2),-- Số dư tài khoản luôn cập nhật ngay sau khi người dùng kết thúc phiên sử dụng máy tính tiệm net
--    loai_TK NVARCHAR(20) NOT NULL,-- Loại tài khoản: "Thường" hoặc "Tạm thời"
--    trang_thai_TK NVARCHAR(20) NOT NULL, -- Trạng thái tài khoản: "Chưa kích hoạt", "Hoạt động", "Khóa", "Đã xóa"
--    nguoidung_id CHAR(10) NULL, -- Khóa ngoại tham chiếu đến bảng nguoidung
--    CONSTRAINT fk_taikhoan_nguoidung FOREIGN KEY (nguoidung_id) REFERENCES nguoidung(nguoidung_id)
--)

--CREATE TABLE maytinh (
--    maytinh_id CHAR(6) CONSTRAINT pk_maytinh PRIMARY KEY,-- Mã máy tính theo cấu trúc MMxxx đối với máy đơn MHxxx đối với máy đôi
--    loai_may NVARCHAR(20) NOT NULL,-- Loại máy tính: "Máy đơn" hoặc "Máy đôi"
--    trang_thai_may NVARCHAR(20) NOT NULL,-- Trạng thái máy: "Trống", "Đang dùng" hoặc "Bảo trì"
--    ghi_chu NVARCHAR(255) NULL -- Ghi chú thêm về máy tính
--)

--CREATE TABLE nhanvien (
--    NV_id CHAR(6) CONSTRAINT pk_nhanvien PRIMARY KEY,-- Mã nhân viên theo cấu trúc NVxxx
--    hoten NVARCHAR(100) NOT NULL,-- Tên nhân viên
--    gioi_tinh NVARCHAR(5) NOT NULL,-- Giới tính: Nam/Nữ
--    chuc_vu NVARCHAR(50) NOT NULL,-- Chức vụ nhân viên: Nhân viên quầy / Nhân viên kỹ thuật / Nhân viên phục vụ
--    ngay_sinh DATE NOT NULL,-- Ngày sinh nhân viên
--    sdt NVARCHAR(15) NULL UNIQUE,-- Số điện thoại nhân viên
--    dia_chi NVARCHAR(255) NULL,-- Địa chỉ nhân viên
--)

--CREATE TABLE taikhoannhanvien (
--    TKNV_id CHAR(10) CONSTRAINT pk_taikhoannhanvien PRIMARY KEY,-- Mã tài khoản nhân viên theo cấu trúc TKNVxxx
--    ten_dang_nhap_NV NVARCHAR(20) UNIQUE NOT NULL,-- Tên đăng nhập nhân viên, duy nhất và không được để trống
--    mat_khau NVARCHAR(20) NOT NULL,-- Mật khẩu nhân viên, không được để trống
--    ngay_tao DATETIME DEFAULT GETDATE(),-- Ngày tạo tài khoản, mặc định là ngày hiện tại
--    NV_id CHAR(6) NULL,-- Khóa ngoại tham chiếu đến bảng nhanvien
--    CONSTRAINT fk_taikhoannhanvien_nhanvien FOREIGN KEY (NV_id) REFERENCES nhanvien(NV_id)
--)

--CREATE TABLE khuyenmai (
--    khuyenmai_id CHAR(8) CONSTRAINT pk_khuyenmai PRIMARY KEY,-- Mã khuyến mãi có cấu trúc KMxxx
--    ten_KM NVARCHAR(50) NOT NULL,-- Tên chương trình khuyến mãi
--    loai_KM NVARCHAR(20) NOT NULL,-- Loại khuyến mãi: "Nạp tiền" hoặc "Dịch vụ ăn uống"
--    mo_ta NVARCHAR(255) NULL,-- Mô tả chi tiết về khuyến mãi
--    doi_tuong NVARCHAR(100) NULL,-- Đối tượng áp dụng khuyến mãi
--    dieu_kien NVARCHAR(255) NULL,-- Điều kiện để được hưởng khuyến mãi
--    ngay_bat_dau DATETIME DEFAULT GETDATE() NOT NULL,-- Ngày bắt đầu khuyến mãi, mặc định là ngày hiện tại
--    ngay_ket_thuc DATE NOT NULL,-- Ngày kết thúc khuyến mãi trong tương lai
--)

--CREATE TABLE dichvuanuong (
--    dichvuanuong_id CHAR(8) CONSTRAINT pk_dichvuanuong PRIMARY KEY,-- Mã dịch vụ ăn uống theo cấu trúc DVxxx
--    ten_mon NVARCHAR(30) NOT NULL,-- Tên món ăn
--    loai_mon NVARCHAR(20) NOT NULL,-- Loại món ăn: "Đồ ăn" hoặc "Đồ uống"
--    don_gia DECIMAL(10, 2) NOT NULL,-- Đơn giá món ăn
--    NV_id CHAR(6) NULL,-- Mã nhân viên quản lý dịch vụ ăn uống
--    CONSTRAINT fk_dichvuanuong_nhanvien FOREIGN KEY (NV_id) REFERENCES nhanvien(NV_id)-- Khóa ngoại tham chiếu đến bảng nhân viên
--)

--CREATE TABLE hoadondichvu (
--    hoadondichvu_id CHAR(12) CONSTRAINT pk_hoadondichvu PRIMARY KEY,-- Mã hóa đơn dịch vụ theo cấu trúc HDDVxxxxx
--    thoi_gian_dat DATETIME DEFAULT GETDATE() NOT NULL,-- Thời gian đặt dịch vụ
--    khuyen_mai_DV DECIMAL(10, 2) DEFAULT 0,-- Khuyến mãi dịch vụ
--    hinh_thuc_TT NVARCHAR(20) NOT NULL,-- Hình thức thanh toán: "Tiền mặt", "Chuyển khoản"
--    tong_tien DECIMAL(10, 2) NOT NULL,-- Tổng tiền dịch vụ khi chưa giảm
--    thanh_tien_DV DECIMAL(10, 2) NOT NULL,-- Thành tiền dịch vụ sau khi giảm
--    nguoidung_id CHAR(10) NOT NULL,-- Khóa ngoại tham chiếu đến bảng nguoidung
--    NV_id CHAR(6) NOT NULL,-- Khóa ngoại tham chiếu đến bảng nhanvien
--    khuyenmai_id CHAR(8),-- Khóa ngoại tham chiếu đến bảng khuyenmai
--    CONSTRAINT fk_hoadondichvu_nguoidung FOREIGN KEY (nguoidung_id) REFERENCES nguoidung(nguoidung_id),
--    CONSTRAINT fk_hoadondichvu_nhanvien FOREIGN KEY (NV_id) REFERENCES nhanvien(NV_id),
--    CONSTRAINT fk_hoadondichvu_khuyenmai FOREIGN KEY (khuyenmai_id) REFERENCES khuyenmai(khuyenmai_id)
--)

--CREATE TABLE hoadonnaptien (
--    hoadonnaptien_id CHAR(12) CONSTRAINT pk_hoadonnaptien PRIMARY KEY,-- Mã hóa đơn nạp tiền theo cấu trúc HDNxxxxxxx
--    so_tien_NT DECIMAL(10, 2) NOT NULL,-- Số tiền nạp
--    hinh_thuc_NT NVARCHAR(20) NOT NULL,-- Hình thức nạp tiền: Tiền mặt, Thẻ cào, Chuyển khoản
--    khuyen_mai_NT DECIMAL(10, 2) DEFAULT 0,-- Khuyến mãi (nếu có)
--    thanh_tien_NT DECIMAL(10, 2) NOT NULL,-- Thành tiền sau khuyến mãi(nếu có)
--    nguoidung_id CHAR(10) NOT NULL,-- Khóa ngoại tham chiếu đến bảng nguoidung
--    NV_id CHAR(6) NOT NULL,-- Khóa ngoại tham chiếu đến bảng nhanvien
--    khuyenmai_id CHAR(8) NULL,-- Khóa ngoại tham chiếu đến bảng khuyenmai (nếu có)
--    CONSTRAINT fk_hoadonnaptien_nguoidung FOREIGN KEY (nguoidung_id) REFERENCES nguoidung(nguoidung_id),
--    CONSTRAINT fk_hoadonnaptien_nhanvien FOREIGN KEY (NV_id) REFERENCES nhanvien(NV_id),
--    CONSTRAINT fk_hoadonnaptien_khuyenmai FOREIGN KEY (khuyenmai_id) REFERENCES khuyenmai(khuyenmai_id)
--)

--CREATE TABLE sucokythuat (
--    sucokythuat_id CHAR(6) CONSTRAINT pk_sucokythuat PRIMARY KEY,-- Mã sự cố kỹ thuật theo cấu trúc KTxxx
--    thoi_gian_yeu_cau DATETIME DEFAULT GETDATE() NOT NULL,-- Thời gian yêu cầu, mặc định là thời gian hiện tại
--    mo_ta_van_de NVARCHAR(255) NULL,-- Mô tả vấn đề
--    trang_thai_su_co NVARCHAR(30) NOT NULL,-- Trạng thái sự cố: "Chưa xử lý", "Đang xử lý", "Đã xử lý"
--    nguoidung_id CHAR(10) NOT NULL,-- Khóa ngoại tham chiếu đến bảng nguoidung
--    maytinh_id CHAR(6) NOT NULL,-- Khóa ngoại tham chiếu đến bảng maytinh
--	NV_id CHAR(6) NOT NULL,-- Khóa ngoại tham chiếu đến bảng nhanvien 
--    CONSTRAINT fk_sucokythuat_nguoidung FOREIGN KEY (nguoidung_id) REFERENCES nguoidung(nguoidung_id),
--    CONSTRAINT fk_sucokythuat_maytinh FOREIGN KEY (maytinh_id) REFERENCES maytinh(maytinh_id),
--	CONSTRAINT fk_sucokythuat_nhanvien FOREIGN KEY (NV_id) REFERENCES nhanvien(NV_id)
--)

--CREATE TABLE tt_sudung (
--    nguoidung_id CHAR(10) NOT NULL,-- Mã người dùng
--    maytinh_id CHAR(6) NOT NULL,-- Mã máy tính
--    gio_bat_dau DATETIME,-- Thời gian bắt đầu sử dụng máy tính
--    gio_ket_thuc DATETIME,-- Thời gian kết thúc sử dụng máy tính
--    so_tien_tru MONEY,-- Số tiền trừ vào tài khoản sau khi kết thúc phiên sử dụng máy tính
--    PRIMARY KEY (nguoidung_id, maytinh_id),-- Khóa chính gồm mã người dùng và mã máy tính
--    CONSTRAINT fk_tt_sudung_nguoidung FOREIGN KEY (nguoidung_id) REFERENCES nguoidung(nguoidung_id),
--    CONSTRAINT fk_tt_sudung_maytinh FOREIGN KEY (maytinh_id) REFERENCES maytinh(maytinh_id)
--)

--CREATE TABLE ct_hoadondichvu (
--    dichvuanuong_id CHAR(8) NOT NULL,-- Mã dịch vụ ăn uống
--    hoadondichvu_id CHAR(12) NOT NULL,-- Mã hóa đơn dịch vụ
--    so_luong INT,-- Số lượng món ăn đặt
--    don_gia MONEY,-- Đơn giá món ăn tại thời điểm đặt
--    PRIMARY KEY (dichvuanuong_id, hoadondichvu_id),-- Khóa chính gồm mã dịch vụ ăn uống và mã hóa đơn dịch vụ
--    CONSTRAINT fk_ct_hoadondichvu_dichvuanuong FOREIGN KEY (dichvuanuong_id) REFERENCES dichvuanuong(dichvuanuong_id),
--    CONSTRAINT fk_ct_hoadondichvu_hoadondichvu FOREIGN KEY (hoadondichvu_id) REFERENCES hoadondichvu(hoadondichvu_id)
--)
--go


-----------------------------------------------------
----Dữ liệu
-----------------------------------------------------


--INSERT INTO nguoidung (nguoidung_id, ho_ten, gioi_tinh, ngay_sinh, sdt) VALUES
--('ND000001', N'Nguyễn Văn An', N'Nam', '2001-05-12', '0901111001'),
--('ND000002', N'Trần Thị Bình', N'Nữ', '2002-11-23', '0901111002'),
--('ND000003', N'Lê Minh Hoàng', N'Nam', '2000-07-30', '0901111003'),
--('ND000004', N'Phạm Thị Hồng', N'Nữ', '1999-03-15', '0901111004'),
--('ND000005', N'Ngô Văn Thắng', N'Nam', '2001-12-05', '0901111005'),
--('ND000006', N'Đinh Thị Hoa', N'Nữ', '2003-04-20', '0901111006'),
--('ND000007', N'Hoàng Gia Bảo', N'Nam', '2004-02-11', '0901111007'),
--('ND000008', N'Vũ Thanh Trúc', N'Nữ', '1998-10-09', '0901111008'),
--('ND000009', N'Bùi Đức Mạnh', N'Nam', '2000-01-22', '0901111009'),
--('ND000010', N'Đoàn Thị Ngọc', N'Nữ', '2001-06-18', '0901111010'),
--('ND000011', N'Trịnh Văn Hậu', N'Nam', '2002-08-21', '0901111011'),
--('ND000012', N'Cao Thị Phương', N'Nữ', '2003-12-13', '0901111012'),
--('ND000013', N'Huỳnh Minh Tâm', N'Nam', '1999-09-27', '0901111013'),
--('ND000014', N'Phan Thị Kiều', N'Nữ', '1998-07-02', '0901111014'),
--('ND000015', N'Võ Quốc Khánh', N'Nam', '2004-11-29', '0901111015'),
--('ND000016', N'Phùng Thị Quỳnh', N'Nữ', '2002-03-07', '0901111016'),
--('ND000017', N'Lý Minh Trí', N'Nam', '2001-01-19', '0901111017'),
--('ND000018', N'Tống Thị Vân', N'Nữ', '2000-10-30', '0901111018'),
--('ND000019', N'Chu Văn Long', N'Nam', '2003-06-24', '0901111019'),
--('ND000020', N'Đặng Kim Anh', N'Nữ', '1999-02-28', '0901111020'),
--('ND000021', N'Nguyễn Thế Phát', N'Nam', '2001-05-17', '0901111021'),
--('ND000022', N'Lê Thị Như Ý', N'Nữ', '2002-09-14', '0901111022'),
--('ND000023', N'Phạm Minh Nhật', N'Nam', '2000-12-21', '0901111023'),
--('ND000024', N'Trần Kim Tuyền', N'Nữ', '2003-04-04', '0901111024'),
--('ND000025', N'Đỗ Đức Thiện', N'Nam', '1998-08-08', '0901111025'),
--('ND000026', N'Vũ Thu Hà', N'Nữ', '2001-03-11', '0901111026'),
--('ND000027', N'Hồ Quốc Huy', N'Nam', '2002-01-25', '0901111027'),
--('ND000028', N'Trương Thị Khánh', N'Nữ', '2000-07-19', '0901111028'),
--('ND000029', N'Bùi Văn Lộc', N'Nam', '1999-10-05', '0901111029'),
--('ND000030', N'Đinh Thúy Vy', N'Nữ', '2004-12-12', '0901111030');

--INSERT INTO taikhoan (TK_id, ten_dang_nhap, mat_khau, so_du, loai_TK, trang_thai_TK, nguoidung_id) VALUES
--('TK000001', '0901111001', 'pass123', 120000, N'Thường', N'Hoạt động', 'ND000001'),
--('TK000002', '0901111002', 'pass123', 80000, N'Thường', N'Hoạt động', 'ND000002'),
--('TK000003', '0901111003', 'pass123', 45000, N'Thường', N'Khóa', 'ND000003'),
--('TK000004', '0901111004', 'pass123', 300000, N'Thường', N'Hoạt động', 'ND000004'),
--('TK000005', '0901111005', 'pass123', 0, N'Thường', N'Đã xóa', 'ND000005'),
--('TK000006', '0901111006', 'pass123', 210000, N'Thường', N'Hoạt động', 'ND000006'),
--('TK000007', '0901111007', 'pass123', 70000, N'Thường', N'Hoạt động', 'ND000007'),
--('TK000008', '0901111008', 'pass123', 5000, N'Thường', N'Hoạt động', 'ND000008'),
--('TK000009', '0901111009', 'pass123', 99000, N'Thường', N'Khóa', 'ND000009'),
--('TK000010', '0901111010', 'pass123', 0, N'Thường', N'Đã xóa', 'ND000010'),
--('TK000011', '0901111011', 'pass123', 170000, N'Thường', N'Hoạt động', 'ND000011'),
--('TK000012', '0901111012', 'pass123', 60000, N'Thường', N'Hoạt động', 'ND000012'),
--('TK000013', '0901111013', 'pass123', 250000, N'Thường', N'Hoạt động', 'ND000013'),
--('TK000014', '0901111014', 'pass123', 90000, N'Thường', N'Khóa', 'ND000014'),
--('TK000015', '0901111015', 'pass123', 0, N'Thường', N'Đã xóa', 'ND000015'),
--('TK000016', '0901111016', 'pass123', 115000, N'Thường', N'Hoạt động', 'ND000016'),
--('TK000017', '0901111017', 'pass123', 35000, N'Thường', N'Hoạt động', 'ND000017'),
--('TK000018', '0901111018', 'pass123', 40000, N'Thường', N'Hoạt động', 'ND000018'),
--('TK000019', '0901111019', 'pass123', 0, N'Thường', N'Chưa kích hoạt', 'ND000019'),
--('TK000020', '0901111020', 'pass123', 150000, N'Thường', N'Hoạt động', 'ND000020'),
--('TK000021', '0901111021', 'pass123', 12000, N'Thường', N'Hoạt động', 'ND000021'),
--('TK000022', '0901111022', 'pass123', 95000, N'Thường', N'Khóa', 'ND000022'),
--('TK000023', '0901111023', 'pass123', 180000, N'Thường', N'Hoạt động', 'ND000023'),
--('TK000024', '0901111024', 'pass123', 50000, N'Thường', N'Hoạt động', 'ND000024'),
--('TK000025', '0901111025', 'pass123', 0, N'Thường', N'Chưa kích hoạt', 'ND000025'),
--('TK000026', '0901111026', 'pass123', 300000, N'Thường', N'Hoạt động', 'ND000026'),
--('TK000027', '0901111027', 'pass123', 60000, N'Thường', N'Hoạt động', 'ND000027'),
--('TK000028', '0901111028', 'pass123', 45000, N'Thường', N'Khóa', 'ND000028'),
--('TK000029', '0901111029', 'pass123', 8000, N'Thường', N'Hoạt động', 'ND000029'),
--('TK000030', '0901111030', 'pass123', 160000, N'Thường', N'Hoạt động', 'ND000030'),
--('TK000031', '0000000000', 'temp123', 15000, N'Tạm thời', N'Hoạt động', NULL),
--('TK000032', '0000000000', 'temp123', 0, N'Tạm thời', N'Chưa kích hoạt', NULL),
--('TK000033', '0000000000', 'temp123', 5000, N'Tạm thời', N'Hoạt động', NULL),
--('TK000034', '0000000000', 'temp123', 2000, N'Tạm thời', N'Hoạt động', NULL),
--('TK000035', '0000000000', 'temp123', 0, N'Tạm thời', N'Đã xóa', NULL),
--('TK000036', '0000000000', 'temp123', 10000, N'Tạm thời', N'Hoạt động', NULL),
--('TK000037', '0000000000', 'temp123', 3000, N'Tạm thời', N'Hoạt động', NULL),
--('TK000038', '0000000000', 'temp123', 0, N'Tạm thời', N'Khóa', NULL),
--('TK000039', '0000000000', 'temp123', 8000, N'Tạm thời', N'Hoạt động', NULL),
--('TK000040', '0000000000', 'temp123', 0, N'Tạm thời', N'Chưa kích hoạt', NULL);

--INSERT INTO maytinh (maytinh_id, loai_may, trang_thai_may, ghi_chu) VALUES
--('MM001', N'Máy đơn', N'Trống', NULL),
--('MM002', N'Máy đơn', N'Đang dùng', N'Khách đang chơi'),
--('MM003', N'Máy đơn', N'Trống', NULL),
--('MM004', N'Máy đơn', N'Bảo trì', N'Đang sửa VGA'),
--('MM005', N'Máy đơn', N'Trống', NULL),
--('MM006', N'Máy đơn', N'Đang dùng', NULL),
--('MM007', N'Máy đơn', N'Trống', NULL),
--('MM008', N'Máy đơn', N'Bảo trì', N'Lỗi nguồn'),
--('MM009', N'Máy đơn', N'Trống', NULL),
--('MM010', N'Máy đơn', N'Đang dùng', N'Khách thuê theo giờ'),
--('MM011', N'Máy đơn', N'Trống', NULL),
--('MM012', N'Máy đơn', N'Trống', NULL),
--('MM013', N'Máy đơn', N'Đang dùng', NULL),
--('MM014', N'Máy đơn', N'Trống', NULL),
--('MM015', N'Máy đơn', N'Bảo trì', N'Vệ sinh máy'),
--('MH001', N'Máy đôi', N'Trống', NULL),
--('MH002', N'Máy đôi', N'Đang dùng', N'2 khách đang chơi'),
--('MH003', N'Máy đôi', N'Trống', NULL),
--('MH004', N'Máy đôi', N'Bảo trì', N'Hỏng bàn phím 1 bên'),
--('MH005', N'Máy đôi', N'Trống', NULL);

--INSERT INTO nhanvien (NV_id, hoten, gioi_tinh, chuc_vu, ngay_sinh, sdt, dia_chi) VALUES
--('NV001', N'Nguyễn Văn Bình', N'Nam', N'Nhân viên quầy', '1995-04-12', '0901111111', N'123 Lê Lợi, Q.1, TP.HCM'),
--('NV002', N'Trần Thị Cẩm', N'Nữ', N'Nhân viên quầy', '1998-06-20', '0902222222', N'45 Nguyễn Huệ, Q.1, TP.HCM'),
--('NV003', N'Lê Văn Công', N'Nam', N'Nhân viên kỹ thuật', '1994-09-15', '0903333333', N'12 Trần Hưng Đạo, Q.5, TP.HCM'),
--('NV004', N'Phạm Thị Duyên', N'Nữ', N'Nhân viên phục vụ', '1999-02-25', '0904444444', N'67 Hai Bà Trưng, Q.3, TP.HCM'),
--('NV005', N'Hoàng Văn Dũng', N'Nam', N'Nhân viên kỹ thuật', '1996-08-05', '0905555555', N'89 Lý Thường Kiệt, Q.10, TP.HCM'),
--('NV006', N'Bùi Thị Hoa', N'Nữ', N'Nhân viên quầy', '1997-11-30', '0906666666', N'21 Nguyễn Thị Minh Khai, Q.1, TP.HCM'),
--('NV007', N'Đỗ Văn Hải', N'Nam', N'Nhân viên phục vụ', '1995-03-18', '0907777777', N'34 Cách Mạng Tháng 8, Q.10, TP.HCM'),
--('NV008', N'Vũ Thị Lan', N'Nữ', N'Nhân viên kỹ thuật', '1993-07-09', '0908888888', N'56 Võ Văn Kiệt, Q.5, TP.HCM'),
--('NV009', N'Ngô Văn Minh', N'Nam', N'Nhân viên quầy', '1998-12-01', '0909999999', N'78 Bùi Viện, Q.1, TP.HCM'),
--('NV010', N'Phan Thị Ngọc', N'Nữ', N'Nhân viên phục vụ', '1996-10-22', '0910000000', N'90 Điện Biên Phủ, Q.Bình Thạnh, TP.HCM'),
--('NV011', N'Đặng Thị Mỹ Hạnh', N'Nữ', N'Nhân viên quầy', '1999-08-17', '0911111111', N'12 Nguyễn Trãi, Q.5, TP.HCM'),
--('NV012', N'Lưu Văn Khánh', N'Nam', N'Nhân viên quầy', '1997-01-09', '0912222222', N'34 Lê Văn Sỹ, Q.3, TP.HCM'),
--('NV013', N'Võ Thị Phương', N'Nữ', N'Nhân viên quầy', '1996-02-14', '0913333333', N'89 Pasteur, Q.1, TP.HCM'),
--('NV014', N'Nguyễn Minh Tuấn', N'Nam', N'Nhân viên quầy', '1995-07-11', '0914444444', N'56 Tôn Đức Thắng, Q.1, TP.HCM'),
--('NV015', N'Nguyễn Thanh Hòa', N'Nam', N'Nhân viên phục vụ', '1998-04-09', '0915555555', N'23 Phạm Văn Đồng, Q.Gò Vấp, TP.HCM'),
--('NV016', N'Trịnh Thị Thu', N'Nữ', N'Nhân viên phục vụ', '1997-12-28', '0916666666', N'11 Hoàng Văn Thụ, Q.Tân Bình, TP.HCM'),
--('NV017', N'Lê Văn Hạo', N'Nam', N'Nhân viên phục vụ', '1995-06-13', '0917777777', N'102 Nguyễn Kiệm, Q.Gò Vấp, TP.HCM'),
--('NV018', N'Dương Minh Quân', N'Nam', N'Nhân viên kỹ thuật', '1992-01-22', '0918888888', N'45 Hồng Bàng, Q.5, TP.HCM'),
--('NV019', N'Phạm Thị Như', N'Nữ', N'Nhân viên kỹ thuật', '1994-03-30', '0919999999', N'77 Lê Quý Đôn, Q.3, TP.HCM'),
--('NV020', N'Đinh Văn Khôi', N'Nam', N'Nhân viên kỹ thuật', '1993-11-05', '0920000000', N'19 Võ Thị Sáu, Q.1, TP.HCM');

--INSERT INTO taikhoannhanvien (TKNV_id, ten_dang_nhap_NV, mat_khau, NV_id) VALUES
--('TKNV001', 'nv001', 'nv123', 'NV001'),
--('TKNV002', 'nv002', 'nv123', 'NV002'),
--('TKNV003', 'nv003', 'nv123', 'NV003'),
--('TKNV004', 'nv004', 'nv123', 'NV004'),
--('TKNV005', 'nv005', 'nv123', 'NV005'),
--('TKNV006', 'nv006', 'nv123', 'NV006'),
--('TKNV007', 'nv007', 'nv123', 'NV007'),
--('TKNV008', 'nv008', 'nv123', 'NV008'),
--('TKNV009', 'nv009', 'nv123', 'NV009'),
--('TKNV010', 'nv010', 'nv123', 'NV010'),
--('TKNV011', 'nv011', 'nv123', 'NV011'),
--('TKNV012', 'nv012', 'nv123', 'NV012'),
--('TKNV013', 'nv013', 'nv123', 'NV013'),
--('TKNV014', 'nv014', 'nv123', 'NV014'),
--('TKNV015', 'nv015', 'nv123', 'NV015'),
--('TKNV016', 'nv016', 'nv123', 'NV016'),
--('TKNV017', 'nv017', 'nv123', 'NV017'),
--('TKNV018', 'nv018', 'nv123', 'NV018'),
--('TKNV019', 'nv019', 'nv123', 'NV019'),
--('TKNV020', 'nv020', 'nv123', 'NV020');

--INSERT INTO khuyenmai (khuyenmai_id, ten_KM, loai_KM, mo_ta, doi_tuong, dieu_kien, ngay_bat_dau, ngay_ket_thuc) VALUES
--('KM001', N'KM Nạp 100k Tặng 10k', N'Nạp tiền', N'Tặng 10.000đ khi nạp từ 100.000đ trở lên', N'Tất cả người dùng', N'Nạp từ 100.000đ', '2025-01-01', '2025-01-31'),
--('KM002', N'Giảm 20% Dịch vụ ăn uống', N'Dịch vụ ăn uống', N'Giảm giá 20% cho tất cả món ăn', N'Tất cả người dùng', N'Không yêu cầu', '2025-02-01', '2025-02-14'),
--('KM003', N'Tặng 15k khi nạp 150k', N'Nạp tiền', N'Tặng 15.000đ khi nạp từ 150.000đ', N'Người dùng thường', N'Nạp từ 150.000đ', '2025-03-01', '2025-03-31'),
--('KM004', N'Giảm 10% máy đôi', N'Dịch vụ ăn uống', N'Giảm giá 10% cho khách đặt máy đôi', N'Người dùng thường', N'Sử dụng máy đôi', '2025-04-01', '2025-04-15'),
--('KM005', N'Mua 2 Tặng 1', N'Dịch vụ ăn uống', N'Áp dụng mua 2 phần nước tặng 1', N'Tất cả người dùng', N'Mua 2 phần nước trở lên', '2025-05-01', '2025-05-10'),
--('KM006', N'Nạp 200k Tặng 30k', N'Nạp tiền', N'Tặng 30.000đ khi nạp từ 200.000đ', N'Tất cả người dùng', N'Nạp từ 200.000đ', '2025-06-01', '2025-06-30'),
--('KM007', N'Giảm 25% Combo mì + nước', N'Dịch vụ ăn uống', N'Combo giảm 25% vào cuối tuần', N'Tất cả người dùng', N'Áp dụng thứ 6–7–CN', '2025-07-01', '2025-07-31'),
--('KM008', N'Tặng 1h chơi khi nạp 300k', N'Nạp tiền', N'Tặng thêm 60 phút chơi máy', N'Tất cả người dùng', N'Nạp từ 300.000đ', '2025-08-01', '2025-08-31'),
--('KM009', N'Ưu đãi hội viên 15%', N'Dịch vụ ăn uống', N'Giảm 15% cho hội viên thân thiết', N'Hội viên', N'Có thẻ hội viên', '2025-09-01', '2025-09-30'),
--('KM010', N'Combo 3 nước giảm 20%', N'Dịch vụ ăn uống', N'Giảm 20% khi mua 3 nước bất kỳ', N'Tất cả người dùng', N'Mua từ 3 nước', '2025-10-01', '2025-10-20'),
--('KM011', N'Khuyến mãi sinh viên 10%', N'Dịch vụ ăn uống', N'Giảm giá 10% cho sinh viên', N'Sinh viên', N'Xuất trình thẻ SV', '2025-11-01', '2025-11-30'),
--('KM012', N'Nạp 500k tặng 100k', N'Nạp tiền', N'Tặng thêm 100.000đ khi nạp 500.000đ', N'Tất cả người dùng', N'Nạp từ 500.000đ', '2025-12-01', '2025-12-31'),
--('KM013', N'Giảm 30% đồ ăn buổi tối', N'Dịch vụ ăn uống', N'Giảm 30% sau 20:00', N'Tất cả người dùng', N'Áp dụng sau 20h', '2025-01-15', '2025-02-15'),
--('KM014', N'Tặng nước khi chơi máy đôi', N'Dịch vụ ăn uống', N'Mỗi nhóm đặt máy đôi tặng 1 chai nước', N'Người dùng thường', N'Chơi máy đôi ≥ 1 giờ', '2025-03-10', '2025-03-25'),
--('KM015', N'Giảm 40% món ăn mới', N'Dịch vụ ăn uống', N'Áp dụng giảm giá cho món mới ra mắt', N'Tất cả người dùng', N'Không yêu cầu', '2025-04-01', '2025-04-20');

--INSERT INTO hoadonnaptien (hoadonnaptien_id, so_tien_NT, hinh_thuc_NT, khuyen_mai_NT, thanh_tien_NT, nguoidung_id, khuyenmai_id, NV_id) VALUES
--('HDN0000001', 50000, N'Tiền mặt', NULL, 50000, 'ND000001', NULL, 'NV001'),
--('HDN0000002', 100000, N'Chuyển khoản', 10000, 90000, 'ND000002', 'KM001', 'NV002'),
--('HDN0000003', 200000, N'Tiền mặt', 20000, 180000, 'ND000007', 'KM003', 'NV006'),
--('HDN0000004', 75000, N'Tiền mặt', NULL, 75000, 'ND000004', NULL, 'NV009'),
--('HDN0000005', 150000, N'Chuyển khoản', 15000, 135000, 'ND000005', 'KM004', 'NV011'),
--('HDN0000006', 120000, N'Tiền mặt', 12000, 108000, 'ND000006', 'KM001', 'NV012'),
--('HDN0000007', 80000, N'Tiền mặt', NULL, 80000, 'ND000007', NULL, 'NV013'),
--('HDN0000008', 50000, N'Chuyển khoản', 5000, 45000, 'ND000008', 'KM003', 'NV014'),
--('HDN0000009', 100000, N'Tiền mặt', 10000, 90000, 'ND000009', 'KM004', 'NV001'),
--('HDN0000010', 250000, N'Tiền mặt', 25000, 225000, 'ND000010', 'KM006', 'NV002'),
--('HDN0000011', 150000, N'Chuyển khoản', 15000, 135000, 'ND000011', 'KM008', 'NV006'),
--('HDN0000012', 90000, N'Tiền mặt', NULL, 90000, 'ND000007', NULL, 'NV009'),
--('HDN0000013', 180000, N'Tiền mặt', 18000, 162000, 'ND000004', 'KM001', 'NV011'),
--('HDN0000014', 70000, N'Chuyển khoản', 7000, 63000, 'ND000014', 'KM003', 'NV012'),
--('HDN0000015', 200000, N'Tiền mặt', 20000, 180000, 'ND000007', 'KM004', 'NV013'),
--('HDN0000016', 50000, N'Tiền mặt', NULL, 50000, 'ND000016', NULL, 'NV014'),
--('HDN0000017', 100000, N'Chuyển khoản', 10000, 90000, 'ND000017', 'KM006', 'NV001'),
--('HDN0000018', 120000, N'Tiền mặt', 12000, 108000, 'ND000004', 'KM008', 'NV002'),
--('HDN0000019', 80000, N'Tiền mặt', NULL, 80000, 'ND000007', NULL, 'NV006'),
--('HDN0000020', 150000, N'Chuyển khoản', 15000, 135000, 'ND000020', 'KM001', 'NV009');

--INSERT INTO dichvuanuong (dichvuanuong_id, ten_mon, loai_mon, don_gia, NV_id) VALUES
--('DV001', N'Mì xào bò', N'Đồ ăn', 35000, 'NV004'),
--('DV002', N'Cơm chiên gà', N'Đồ ăn', 40000, 'NV007'),
--('DV003', N'Mì cay cấp 1', N'Đồ ăn', 32000, 'NV010'),
--('DV004', N'Xúc xích chiên', N'Đồ ăn', 20000, 'NV012'),
--('DV005', N'Khoai tây chiên', N'Đồ ăn', 25000, 'NV014'),
--('DV006', N'Bánh mì pate', N'Đồ ăn', 18000, 'NV017'),
--('DV007', N'Cơm gà xối mỡ', N'Đồ ăn', 45000, 'NV004'),
--('DV008', N'Mì trứng', N'Đồ ăn', 28000, 'NV007'),
--('DV009', N'Bánh bao thịt', N'Đồ ăn', 15000, 'NV010'),
--('DV010', N'Bánh gà viên', N'Đồ ăn', 22000, 'NV012'),
--('DV011', N'Pepsi lon', N'Đồ uống', 15000, 'NV014'),
--('DV012', N'Coca-Cola lon', N'Đồ uống', 15000, 'NV017'),
--('DV013', N'Trà chanh', N'Đồ uống', 12000, 'NV004'),
--('DV014', N'Nước suối Aquafina', N'Đồ uống', 10000, 'NV007'),
--('DV015', N'Sting dâu', N'Đồ uống', 15000, 'NV010'),
--('DV016', N'Sữa tươi Milo', N'Đồ uống', 18000, 'NV012'),
--('DV017', N'Trà đào cam sả', N'Đồ uống', 20000, 'NV014'),
--('DV018', N'Cafe đen đá', N'Đồ uống', 18000, 'NV017'),
--('DV019', N'Cafe sữa đá', N'Đồ uống', 20000, 'NV004'),
--('DV020', N'Nước cam ép', N'Đồ uống', 22000, 'NV007');

--INSERT INTO hoadondichvu (hoadondichvu_id, thoi_gian_dat, khuyen_mai_DV, hinh_thuc_TT, tong_tien, thanh_tien_DV, nguoidung_id, khuyenmai_id, NV_id) VALUES 
--('HDDV00001', '2025-08-01 09:20:00', 0, N'Tiền mặt', 70000, 70000, 'ND000001', NULL, 'NV001'),
--('HDDV00002', '2025-08-01 11:45:00', 5000, N'Tiền mặt', 80000, 75000, 'ND000002', 'KM002', 'NV001'),
--('HDDV00003', '2025-08-03 15:10:00', 0, N'Chuyển khoản', 45000, 45000, 'ND000003', NULL, 'NV002'),
--('HDDV00004', '2025-08-04 14:50:00', 3000, N'Tiền mặt', 60000, 57000, 'ND000004', 'KM002', 'NV002'),
--('HDDV00005', '2025-08-05 09:05:00', 0, N'Tiền mặt', 15000, 15000, 'ND000005', NULL, 'NV006'),
--('HDDV00006', '2025-08-06 12:40:00', 5000, N'Chuyển khoản', 95000, 90000, 'ND000006', 'KM005', 'NV006'),
--('HDDV00007', '2025-08-07 10:00:00', 0, N'Tiền mặt', 20000, 20000, 'ND000007', NULL, 'NV009'),
--('HDDV00008', '2025-08-10 16:30:00', 7000, N'Tiền mặt', 110000, 103000, 'ND000008', 'KM007', 'NV009'),
--('HDDV00009', '2025-08-12 13:25:00', 6000, N'Chuyển khoản', 62000, 56000, 'ND000009', 'KM009', 'NV011'),
--('HDDV00010', '2025-08-14 17:45:00', 0, N'Tiền mặt', 44000, 44000, 'ND000010', NULL, 'NV011'),
--('HDDV00011', '2025-08-15 08:55:00', 5000, N'Tiền mặt', 70000, 65000, 'ND000011', 'KM010', 'NV012'),
--('HDDV00012', '2025-08-16 12:10:00', 0, N'Chuyển khoản', 38000, 38000, 'ND000012', NULL, 'NV012'),
--('HDDV00013', '2025-08-17 14:25:00', 8000, N'Tiền mặt', 95000, 87000, 'ND000013', 'KM011', 'NV013'),
--('HDDV00014', '2025-08-18 15:00:00', 0, N'Chuyển khoản', 30000, 30000, 'ND000014', NULL, 'NV013'),
--('HDDV00015', '2025-08-19 18:20:00', 7000, N'Tiền mặt', 85000, 78000, 'ND000015', 'KM013', 'NV014');

--INSERT INTO ct_hoadondichvu (dichvuanuong_id, hoadondichvu_id, so_luong, don_gia) VALUES
--('DV001', 'HDDV00001', 2, 35000),
--('DV011', 'HDDV00001', 2, 15000),
--('DV003', 'HDDV00002', 1, 32000),
--('DV017', 'HDDV00002', 2, 20000),
--('DV005', 'HDDV00003', 2, 25000),
--('DV020', 'HDDV00004', 3, 22000),
--('DV002', 'HDDV00004', 1, 40000),
--('DV014', 'HDDV00005', 1, 10000),
--('DV007', 'HDDV00006', 1, 45000),
--('DV010', 'HDDV00006', 2, 22000),
--('DV017', 'HDDV00007', 1, 20000),
--('DV002', 'HDDV00008', 2, 40000),
--('DV019', 'HDDV00008', 1, 20000),
--('DV010', 'HDDV00009', 2, 22000),
--('DV012', 'HDDV00010', 1, 15000),
--('DV004', 'HDDV00010', 1, 20000),
--('DV006', 'HDDV00011', 2, 18000),
--('DV001', 'HDDV00011', 1, 35000),
--('DV020', 'HDDV00012', 1, 22000),
--('DV015', 'HDDV00013', 3, 15000),
--('DV014', 'HDDV00013', 2, 10000),
--('DV018', 'HDDV00014', 2, 18000),
--('DV003', 'HDDV00015', 2, 32000),
--('DV011', 'HDDV00015', 1, 15000);


--INSERT INTO tt_sudung (nguoidung_id, maytinh_id, gio_bat_dau, gio_ket_thuc, so_tien_tru) VALUES
--('ND000001', 'MM001', '2025-08-01 08:00:00', '2025-08-01 09:00:00', 10000),
--('ND000002', 'MM002', '2025-08-01 08:30:00', NULL, NULL),
--('ND000003', 'MH001', '2025-08-01 09:00:00', '2025-08-01 10:30:00', 20000),
--('ND000004', 'MM003', '2025-08-01 09:15:00', '2025-08-01 10:15:00', 10000),
--('ND000005', 'MH002', '2025-08-01 10:00:00', '2025-08-01 11:00:00', 15000),
--('ND000006', 'MM013', '2025-08-01 11:00:00', NULL, NULL),
--('ND000007', 'MH003', '2025-08-01 11:30:00', '2025-08-01 13:00:00', 20000),
--('ND000008', 'MM005', '2025-08-01 13:00:00', '2025-08-01 14:00:00', 10000),
--('ND000009', 'MM006', '2025-08-01 13:15:00', NULL, NULL),
--('ND000010', 'MH004', '2025-08-01 14:00:00', '2025-08-01 15:00:00', 15000),
--('ND000011', 'MM007', '2025-08-02 08:30:00', '2025-08-02 09:30:00', 12000),
--('ND000012', 'MH005', '2025-08-02 09:00:00', '2025-08-02 10:15:00', 18000),
--('ND000013', 'MM008', '2025-08-02 09:45:00', '2025-08-02 11:00:00', 16000),
--('ND000014', 'MH001', '2025-08-02 10:15:00', '2025-08-02 11:30:00', 20000),
--('ND000015', 'MM009', '2025-08-02 11:00:00', '2025-08-02 12:00:00', 10000),
--('ND000016', 'MM010', '2025-08-02 12:30:00', NULL, NULL),
--('ND000017', 'MH002', '2025-08-02 13:00:00', NULL, NULL),
--('ND000018', 'MM011', '2025-08-02 14:00:00', '2025-08-02 15:00:00', 15000),
--('ND000019', 'MH003', '2025-08-02 15:00:00', '2025-08-02 16:30:00', 20000),
--('ND000020', 'MM012', '2025-08-02 15:30:00', '2025-08-02 16:30:00', 12000);

--INSERT INTO sucokythuat (sucokythuat_id, thoi_gian_yeu_cau, mo_ta_van_de, trang_thai_su_co, nguoidung_id, maytinh_id, NV_id) VALUES
--('KT001', '2025-08-01 09:10:00', N'Tạm dừng hoạt động 1 tuần', N'Chưa xử lý', 'ND000001', 'MM001', 'NV003'),
--('KT002', '2025-08-01 10:20:00', N'Máy bị treo', N'Đang xử lý', 'ND000002', 'MH001', 'NV005'),
--('KT003', '2025-08-01 11:45:00', N'Màn hình nhấp nháy', N'Đã xử lý', 'ND000003', 'MM004', 'NV008'),
--('KT004', '2025-08-01 13:30:00', N'Không kết nối Internet', N'Chưa xử lý', 'ND000004', 'MH003', 'NV018'),
--('KT005', '2025-08-01 14:15:00', N'Chuột không hoạt động', N'Đang xử lý', 'ND000005', 'MM006', 'NV019'),
--('KT006', '2025-08-02 09:05:00', N'Bàn phím kẹt phím', N'Chưa xử lý', 'ND000006', 'MM007', 'NV020'),
--('KT007', '2025-08-02 10:30:00', N'Máy chạy chậm', N'Đang xử lý', 'ND000007', 'MH005', 'NV003'),
--('KT008', '2025-08-02 11:50:00', N'Tin nhắn lỗi khi đăng nhập', N'Đã xử lý', 'ND000008', 'MM010', 'NV005'),
--('KT009', '2025-08-02 13:10:00', N'Ứng dụng tự tắt', N'Chưa xử lý', 'ND000009', 'MH002', 'NV008'),
--('KT010', '2025-08-02 14:40:00', N'Máy phát ra tiếng ồn lớn', N'Đang xử lý', 'ND000010', 'MM012', 'NV018');


------------------------------------------------------
---- 4.1 Tạo và phân quyền cho CSDL
------------------------------------------------------

---- 4.1.1 Tạo login và user với quyền db_owner trên database QLDVTN login này được coi là Chủ tiệm
---------------------------------------------------------------------------------------------
--use master;
--GO
--CREATE Login uyennhi with PASSWORD = '123';
--GO
--use QLDVTN;
--create user uyennhi for login uyennhi;
--GO
--use QLDVTN;
--alter role db_owner add member uyennhi;

-- 4.1.2 Tạo role và tự động phân quyền cho nhân viên của tiệm net
------------------------------------------------------------------
---- Role cho nhân viên quầy
--CREATE ROLE role_nhanvien_quay;
---- Role cho nhân viên phục vụ
--CREATE ROLE role_nhanvien_phucvu;
---- Role cho nhân viên kỹ thuật
--CREATE ROLE role_nhanvien_kythuat;

---- Nhân viên quầy được quyền SELECT, INSERT, UPDATE, DELETE trên bảng liên quan
--GRANT SELECT, INSERT, UPDATE, DELETE ON nguoidung TO role_nhanvien_quay;
--GRANT SELECT, INSERT, UPDATE, DELETE ON taikhoan TO role_nhanvien_quay;
--GRANT SELECT, INSERT, UPDATE, DELETE ON hoadonnaptien TO role_nhanvien_quay;
--GRANT SELECT, INSERT, UPDATE, DELETE ON hoadondichvu TO role_nhanvien_quay;
--GRANT SELECT, INSERT, UPDATE, DELETE ON tt_sudung TO role_nhanvien_quay;
--GRANT SELECT ON khuyenmai TO role_nhanvien_quay;

---- Nhân viên phục vụ
--GRANT SELECT, INSERT, UPDATE, DELETE ON dichvuanuong TO role_nhanvien_phucvu;
--GRANT SELECT, INSERT, UPDATE, DELETE ON ct_hoadondichvu TO role_nhanvien_phucvu;
--GRANT SELECT ON khuyenmai TO role_nhanvien_phucvu;

---- Nhân viên kỹ thuật
--GRANT SELECT, INSERT, UPDATE, DELETE ON maytinh TO role_nhanvien_kythuat;
--GRANT SELECT, INSERT, UPDATE, DELETE ON sucokythuat TO role_nhanvien_kythuat;

----Tự động tạo login và user cho từng nhân viên
--DECLARE @sql NVARCHAR(MAX) = '';

--SELECT @sql = @sql +
--'IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = ''' + TKNV_id + ''')
--    CREATE LOGIN [' + TKNV_id + '] WITH PASSWORD = ''' + mat_khau + '''; ' + CHAR(13) +
--'IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = ''' + TKNV_id + ''')
--    CREATE USER [' + TKNV_id + '] FOR LOGIN [' + TKNV_id + ']; ' + CHAR(13) +
--'ALTER ROLE ' +
--CASE nv.chuc_vu -- Gán nhân viên vào role tương ứng
--    WHEN N'Nhân viên quầy' THEN 'role_nhanvien_quay'
--    WHEN N'Nhân viên phục vụ' THEN 'role_nhanvien_phucvu'
--    WHEN N'Nhân viên kỹ thuật' THEN 'role_nhanvien_kythuat'
--    ELSE 'db_datareader' -- phòng khi có chức vụ khác
--END +
--' ADD MEMBER [' + TKNV_id + '];' + CHAR(13)
--FROM taikhoannhanvien tk
--JOIN nhanvien nv ON tk.NV_id = nv.NV_id;

--EXEC sp_executesql @sql;

---- Kiểm tra user nằm trong role nào
--SELECT  
--    dp.name AS UserName,
--    rp.name AS RoleName
--FROM sys.database_role_members drm
--JOIN sys.database_principals rp ON drm.role_principal_id = rp.principal_id
--JOIN sys.database_principals dp ON drm.member_principal_id = dp.principal_id
--WHERE dp.name LIKE 'TKNV%';


----------------------------------------------------
-- 4.2 INDEX
----------------------------------------------------


-- 4.2.1 Tạo Clustered Index (CI) trên bảng taikhoan
----------------------------------------------------
ALTER TABLE taikhoan
DROP CONSTRAINT pk_taikhoan;

ALTER TABLE taikhoan
ADD CONSTRAINT pk_taikhoan
PRIMARY KEY NONCLUSTERED (TK_id);

CREATE CLUSTERED INDEX CI_TK_id
on taikhoan(TK_id);

-- Kiểm tra 
SELECT * FROM taikhoan
WHERE TK_id = 'TK000006';

-- 4.2.2 Tạo Non-Clustered Index trên cột ten_dang_nhap
-------------------------------------------------------
CREATE NONCLUSTERED INDEX NIC_ten_dang_nhap
ON taikhoan (ten_dang_nhap);

-- Kiểm tra 
SELECT * FROM taikhoan
WHERE TK_id = 'TK000008';

-- 4.2.3 Tạo Non-Clustered Unique Index trên cột ten_mon
--------------------------------------------------------
-- Tên món của bảng dichvuanuong là độc nhất
CREATE UNIQUE NONCLUSTERED INDEX UQ_ten_mon_dichvuanuong
ON dichvuanuong (ten_mon);

-- Kiểm tra 
SELECT * FROM dichvuanuong
WHERE don_gia <= 20000;

-- 4.2.4 Tạo Filtered Index cho cột số dư
-----------------------------------------
CREATE NONCLUSTERED INDEX NCI_FI_so_du
ON taikhoan(so_du)
WHERE so_du > 10000;

-- Kiểm tra 
SELECT * FROM taikhoan 
WHERE so_du > 10000;

-- 4.2.5 Tạo Covering Non-Clustered Index
-----------------------------------------
CREATE NONCLUSTERED INDEX NCI_so_du_covering
on taikhoan(so_du)
INCLUDE(ten_dang_nhap, mat_khau, loai_TK);

-- Kiểm tra 
SELECT ten_dang_nhap, mat_khau, so_du, loai_TK FROM taikhoan
WHERE so_du >= 10000;


-----------------------------------------------------------
-- 4.3 VIEW
-----------------------------------------------------------


-- 4.3.1 SIMPLE VIEW
--------------------
go
CREATE OR ALTER VIEW vw_nguoidung
AS
SELECT
    ho_ten,
    gioi_tinh,
    ngay_sinh,
    sdt
FROM nguoidung;

-- Kiểm tra 
go
SELECT * FROM vw_nguoidung;

-- 4.3.2 Tạo Complex View xem đầy đủ thông tin nạp tiền của người dùng
----------------------------------------------------------------------
go
CREATE OR ALTER VIEW vw_thongtin_hoadonnaptien
AS
SELECT 
    hd.hoadonnaptien_id,
    nd.ho_ten AS ten_nguoidung,
    nd.sdt AS so_dien_thoai,
    hd.so_tien_NT,
    hd.khuyen_mai_NT,
    hd.thanh_tien_NT,
    hd.hinh_thuc_NT,
    nv.hoten AS ten_nhanvien,
    km.ten_KM
FROM hoadonnaptien hd
JOIN nguoidung nd
        ON hd.nguoidung_id = nd.nguoidung_id
JOIN nhanvien nv
        ON hd.NV_id = nv.NV_id
LEFT JOIN khuyenmai km
        ON hd.khuyenmai_id = km.khuyenmai_id;

-- Kiểm tra 
go
SELECT * FROM vw_thongtin_hoadonnaptien
WHERE hoadonnaptien_id LIKE '%7%';

-- 4.3.3 Tạo Complex View theo dõi khách đang sử dụng máy
---------------------------------------------------------
go
CREATE OR ALTER VIEW vw_nguoidung_dangsudung
AS
SELECT 
    mt.maytinh_id,
    mt.loai_may,
    mt.trang_thai_may,
    nd.nguoidung_id,
    nd.ho_ten AS ten_nguoidung,
    nd.sdt AS so_dien_thoai,
    sd.gio_bat_dau,
    sd.gio_ket_thuc,
    DATEDIFF(MINUTE, sd.gio_bat_dau, GETDATE()) AS so_phut_da_dung
FROM tt_sudung sd
JOIN nguoidung nd
        ON sd.nguoidung_id = nd.nguoidung_id
JOIN maytinh mt
        ON sd.maytinh_id = mt.maytinh_id
WHERE sd.gio_ket_thuc IS NULL
      AND mt.trang_thai_may = N'Đang dùng';

-- Kiểm tra 
go
SELECT * FROM vw_nguoidung_dangsudung;

-- 4.3.4 Tạo Complex View thống kê doanh thu dịch vụ ăn uống
------------------------------------------------------------
go
CREATE OR ALTER VIEW vw_doanhthu_anuong
AS
SELECT 
    dv.dichvuanuong_id,
    dv.ten_mon,
    dv.loai_mon,
    SUM(ct.so_luong) AS tong_so_luong_ban,
    SUM(ct.so_luong * ct.don_gia) AS doanh_thu,
    MIN(hd.thoi_gian_dat) AS tu_ngay,
    MAX(hd.thoi_gian_dat) AS den_ngay
FROM ct_hoadondichvu ct
JOIN dichvuanuong dv 
    ON ct.dichvuanuong_id = dv.dichvuanuong_id
JOIN hoadondichvu hd 
    ON ct.hoadondichvu_id = hd.hoadondichvu_id
GROUP BY 
    dv.dichvuanuong_id,
    dv.ten_mon,
    dv.loai_mon;

-- Kiểm tra 
go
SELECT * FROM vw_doanhthu_anuong
WHERE dichvuanuong_id = 'DV010';


---------------------------------------------------------
-- 4.4 PROCEDURE
---------------------------------------------------------


-- 4.4.1 Tạo thủ tục hiển thị thông tin dịch vụ ăn uống
--------------------------------------------
-- Viết thủ tục hiển thị thông tin với đầu vào là id của một dichvuanuong
go
CREATE OR ALTER PROC usp_GetDichVuInfo
    @p_dichvu_id CHAR(8)  -- đầu vào: mã dịch vụ ăn uống
AS
BEGIN
    -- Không cần TRY/CATCH vì chỉ có SELECT
    DECLARE 
        @v_ten_mon NVARCHAR(30),
        @v_loai_mon NVARCHAR(20),
        @v_don_gia DECIMAL(10,2);

    -- Lấy thông tin món ăn
    SELECT 
        @v_ten_mon = ten_mon,
        @v_loai_mon = loai_mon,
        @v_don_gia = don_gia
    FROM dichvuanuong
    WHERE dichvuanuong_id = @p_dichvu_id;

    -- In ra kết quả trực tiếp trong PROC
    PRINT N'*** THÔNG TIN DỊCH VỤ ĂN UỐNG ***';
    PRINT N'Mã dịch vụ : ' + @p_dichvu_id;
    PRINT N'Tên món     : ' + @v_ten_mon;
    PRINT N'Loại món    : ' + @v_loai_mon;
    PRINT N'Đơn giá     : ' + CAST(@v_don_gia AS NVARCHAR(20));
END;

-- Kiểm tra 
EXEC usp_GetDichVuInfo 'DV001';

-- 4.4.2 Tạo thủ tục hiển thị tài khoản theo số dư tối thiểu
------------------------------------------------------------
go
CREATE OR ALTER PROC usp_GetTaiKhoanBySoDu
    @p_MinSoDu DECIMAL(10,2)   -- Số dư tối thiểu do người dùng nhập
AS
BEGIN
    SELECT *
    FROM taikhoan
    WHERE so_du > @p_MinSoDu;
END;

-- Kiểm tra 
EXEC usp_GetTaiKhoanBySoDu @p_MinSoDu = 100000;

-- 4.4.3 Tạo thủ tục thêm tài khoản mới và dữ liệu liên quan
------------------------------------------------------------
-- Viết thủ tục thêm 1 tài khoản mới và các bảng liên kết với bảng taikhoan
go
CREATE OR ALTER PROC usp_AddNewTaiKhoan
    @p_TK_id CHAR(10),
    @p_ten_dang_nhap NVARCHAR(15),
    @p_mat_khau NVARCHAR(20),
    @p_so_du DECIMAL(10,2),
    @p_loai_TK NVARCHAR(20),      
    @p_trang_thai_TK NVARCHAR(20)  
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @next INT;
        DECLARE @new_nguoidung_id CHAR(10) = NULL;

        -- 1. Nếu là tài khoản thường -> tự động tạo người dùng
        IF (@p_loai_TK = N'Thường')
        BEGIN
            -- Sinh mã người dùng theo format NDxxxxxx (lấy số từ TK_id)
            SELECT @next = ISNULL(MAX(CAST(SUBSTRING(nguoidung_id, 3, 6) AS INT)), 0) + 1
            FROM nguoidung;
            SET @new_nguoidung_id = 'ND' + RIGHT('000000' + CAST(@next AS VARCHAR(6)), 6);

            -- Thêm người dùng mới
            INSERT INTO nguoidung (nguoidung_id, ho_ten, gioi_tinh, ngay_sinh, sdt)
            VALUES (@new_nguoidung_id, NULL, NULL, NULL, @p_ten_dang_nhap);
        END

        -- 2. Thêm vào bảng tài khoản
        INSERT INTO taikhoan (TK_id, ten_dang_nhap, mat_khau, so_du, loai_TK, trang_thai_TK, nguoidung_id)
        VALUES (@p_TK_id, @p_ten_dang_nhap, @p_mat_khau, @p_so_du, @p_loai_TK, @p_trang_thai_TK, @new_nguoidung_id);

        COMMIT;
        PRINT N'Thêm tài khoản mới thành công.';

        IF (@new_nguoidung_id IS NOT NULL)
            PRINT N'Đã tự động tạo người dùng: ' + @new_nguoidung_id;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT N'Đã xảy ra lỗi: ' + ERROR_MESSAGE();
    END CATCH
END

-- Kiểm tra 
-- Thêm tài khoản tạm thời
EXEC usp_AddNewTaiKhoan
    @p_TK_id = 'TK000201',
    @p_ten_dang_nhap = '0000000000',
    @p_mat_khau = '123456',
    @p_so_du = 0,
    @p_loai_TK = N'Tạm thời',
    @p_trang_thai_TK = N'Hoạt động';

SELECT * from taikhoan
where TK_id = 'TK000201';

-- Kiểm tra 
-- Thêm tài khoản thường
EXEC usp_AddNewTaiKhoan
    @p_TK_id = 'TK000202',
    @p_ten_dang_nhap = '0987654321',
    @p_mat_khau = 'matkhau1',
    @p_so_du = 100000,
    @p_loai_TK = N'Thường',
    @p_trang_thai_TK = N'Chưa kích hoạt';

SELECT * from taikhoan
where TK_id = 'TK000202';

select * from nguoidung
where nguoidung_id = 'ND000031';

-- -- 4.4.4 Tạo thủ tục thống kê nạp tiền theo người dùng
---------------------------------------------------------
-- Viết thủ tục thống kê hoadonnaptien theo nguoidung
go
CREATE OR ALTER PROC usp_ThongKeNapTienTheoNguoiDung
    @p_nguoidung_id CHAR(10) = NULL  -- NULL = thống kê tất cả người dùng
AS
BEGIN
    SELECT 
        nd.nguoidung_id,
        nd.ho_ten,
        nd.sdt,

        COUNT(hd.hoadonnaptien_id) AS total_transactions,     -- Tổng số lần nạp
        SUM(hd.so_tien_NT) AS total_nap_tien,                 -- Tổng số tiền nạp
        SUM(hd.khuyen_mai_NT) AS total_khuyen_mai,            -- Tổng tiền khuyến mãi
        SUM(hd.thanh_tien_NT) AS total_thanh_tien,            -- Tổng tiền cuối cùng

        MIN(hd.hoadonnaptien_id) AS first_bill,               -- Mã HD đầu tiên
        MAX(hd.hoadonnaptien_id) AS latest_bill               -- Mã HD mới nhất

    FROM nguoidung nd
    LEFT JOIN hoadonnaptien hd ON nd.nguoidung_id = hd.nguoidung_id

    WHERE 
        (@p_nguoidung_id IS NULL OR nd.nguoidung_id = @p_nguoidung_id)

    GROUP BY nd.nguoidung_id, nd.ho_ten, nd.sdt

    ORDER BY total_transactions DESC;
END

-- Kiểm tra 
EXEC usp_ThongKeNapTienTheoNguoiDung;

-- 4.4.5 Tạo thủ tục tìm kiếm dịch vụ ăn uống
---------------------------------------------
-- Viết thủ tục để tìm kiếm dichvuanuong
go
CREATE OR ALTER PROC usp_TimKiemDichVuAnUong
    @p_tuKhoa NVARCHAR(255) = NULL,        -- tìm theo tên món, loại món, tên NV
    @p_loai_mon NVARCHAR(20) = NULL,       -- Đồ ăn / Đồ uống
    @p_minPrice DECIMAL(10,2) = NULL,      -- Giá tối thiểu
    @p_maxPrice DECIMAL(10,2) = NULL,      -- Giá tối đa
    @p_NV_id CHAR(6) = NULL                -- Tìm theo nhân viên phụ trách
AS
BEGIN
    SELECT DISTINCT
           dv.dichvuanuong_id,
           dv.ten_mon,
           dv.loai_mon,
           dv.don_gia,
           dv.NV_id,
           nv.hoten AS ten_nhan_vien,
           nv.gioi_tinh,
           nv.sdt
    FROM dichvuanuong dv
    LEFT JOIN nhanvien nv ON dv.NV_id = nv.NV_id
    WHERE
        -- Tìm từ khóa theo nhiều cột
        (
            @p_tuKhoa IS NULL
            OR dv.ten_mon LIKE '%' + lower(@p_tuKhoa) + '%'
            OR dv.loai_mon LIKE '%' + lower(@p_tuKhoa) + '%'
            OR nv.hoten LIKE '%' + lower(@p_tuKhoa) + '%'
        )

        -- Lọc theo loại món
        AND ( @p_loai_mon IS NULL OR lower(dv.loai_mon) = lower(@p_loai_mon) )

        -- Lọc giá tối thiểu
        AND ( @p_minPrice IS NULL OR dv.don_gia >= @p_minPrice )

        -- Lọc giá tối đa
        AND ( @p_maxPrice IS NULL OR dv.don_gia <= @p_maxPrice )

        -- Lọc theo nhân viên quản lý dịch vụ
        AND ( @p_NV_id IS NULL OR lower(dv.NV_id) = lower(@p_NV_id) )
END

-- Kiểm tra 
EXEC usp_TimKiemDichVuAnUong
    @p_tuKhoa = N'mì',
    @p_minPrice = 20000;


--------------------------------------------------------------
-- 4.5 TRIGGER
--------------------------------------------------------------


-- 4.5.1 Ứng dụng TRIGGER AFTER dùng để ghi log(lịch sử dữ liệu)
---------------------------------------------------------------
-- Tạo bảng để ghi log, làm 1 lần duy nhất
drop table if exists table_log;
create table table_log(
    log_id INT IDENTITY(1,1) CONSTRAINT pk_table_log PRIMARY KEY,
    table_name NVARCHAR(100) NOT NULL, -- Tên bảng bị thay đổi
    type_change NVARCHAR(50) NOT NULL, -- Loại thay đổi: INSERT, UPDATE, DELETE
    record_id CHAR(20), -- ID của bản ghi bị thay đổi
    column_name NVARCHAR(100), -- Tên cột bị thay đổi(chỉ dùng cho UPDATE)
    old_value NVARCHAR(MAX), -- Giá trị cũ (chỉ dùng cho UPDATE, DELETE)
    new_value NVARCHAR(MAX), -- Giá trị mới (chỉ dùng cho INSERT, UPDATE)
    changed_by NVARCHAR(100) DEFAULT SUSER_SNAME(), -- Người thực hiện thay đổi
    changed_date DATETIME DEFAULT GETDATE() -- Thời gian thay đổi
)

-- Viết trigger after tự động kích hoạt khi gặp các sưu kiện INSERT bảng taikhoan
go
CREATE OR ALTER TRIGGER trigg_taikhoan_log_insert
ON taikhoan
AFTER INSERT
AS
BEGIN
    INSERT INTO table_log (table_name, type_change, record_id, column_name, old_value, new_value, changed_by, changed_date)
    SELECT 
        N'taikhoan',                      -- Tên bảng
        N'INSERT',                        -- Loại thay đổi
        inserted.TK_id,                   -- ID bản ghi được thêm
        NULL,                             -- Không có cột thay đổi trong INSERT
        NULL,                             -- old_value = NULL
        -- new_value: Ghi mô tả tài khoản mới thêm
        N'Tên đăng nhập: ' + inserted.ten_dang_nhap 
            + N', Loại TK: ' + inserted.loai_TK
            + N', Trạng thái: ' + inserted.trang_thai_TK
            + N', Số dư: ' + CAST(inserted.so_du AS NVARCHAR(20))
            + N', Người dùng ID: ' + ISNULL(inserted.nguoidung_id, N'NULL'),
        SUSER_SNAME(),                    -- Người thực hiện
        GETDATE()                         -- Thời điểm
    FROM inserted;

    PRINT N'Đã thêm bản ghi vào bảng taikhoan và ghi log thành công.';
END
go

-- Kiểm tra trigger 
INSERT INTO taikhoan (TK_id, ten_dang_nhap, mat_khau, so_du, loai_TK, trang_thai_TK, nguoidung_id)
VALUES ('TK000041', '0901234567', 'abc123', 50000, N'Thường', N'Hoạt động', 'ND000021');

-- Kiểm tra bảng log
SELECT * FROM table_log;

-- Viết trigger after tự động kích hoạt khi gặp các sưu kiện UPDATE bảng taikhoan
go
CREATE OR ALTER TRIGGER trigg_taikhoan_log_update
ON taikhoan
AFTER UPDATE
AS
BEGIN
    -- 1. Cột ten_dang_nhap
    IF UPDATE(ten_dang_nhap)
    BEGIN
        INSERT INTO table_log
        SELECT
            N'taikhoan',
            N'UPDATE',
            inserted.TK_id,
            N'ten_dang_nhap',
            deleted.ten_dang_nhap,
            inserted.ten_dang_nhap,
            SUSER_SNAME(),
            GETDATE()
        FROM inserted 
        JOIN deleted ON inserted.TK_id = deleted.TK_id
        WHERE inserted.ten_dang_nhap <> deleted.ten_dang_nhap;
    END

    -- 2. Cột mat_khau
    IF UPDATE(mat_khau)
    BEGIN
        INSERT INTO table_log
        SELECT
            N'taikhoan',
            N'UPDATE',
            inserted.TK_id,
            N'mat_khau',
            deleted.mat_khau,
            inserted.mat_khau,
            SUSER_SNAME(),
            GETDATE()
        FROM inserted 
        JOIN deleted ON inserted.TK_id = deleted.TK_id
        WHERE inserted.mat_khau <> deleted.mat_khau;
    END

    -- 3. Cột so_du
    IF UPDATE(so_du)
    BEGIN
        INSERT INTO table_log
        SELECT
            N'taikhoan',
            N'UPDATE',
            inserted.TK_id,
            N'so_du',
            CAST(deleted.so_du AS NVARCHAR(50)),
            CAST(inserted.so_du AS NVARCHAR(50)),
            SUSER_SNAME(),
            GETDATE()
        FROM inserted 
        JOIN deleted ON inserted.TK_id = deleted.TK_id
        WHERE inserted.so_du <> deleted.so_du;
    END

    -- 4. Cột loai_TK
    IF UPDATE(loai_TK)
    BEGIN
        INSERT INTO table_log
        SELECT
            N'taikhoan',
            N'UPDATE',
            inserted.TK_id,
            N'loai_TK',
            deleted.loai_TK,
            inserted.loai_TK,
            SUSER_SNAME(),
            GETDATE()
        FROM inserted 
        JOIN deleted ON inserted.TK_id = deleted.TK_id
        WHERE inserted.loai_TK <> deleted.loai_TK;
    END

    -- 5. Cột trang_thai_TK
    IF UPDATE(trang_thai_TK)
    BEGIN
        INSERT INTO table_log
        SELECT
            N'taikhoan',
            N'UPDATE',
            inserted.TK_id,
            N'trang_thai_TK',
            deleted.trang_thai_TK,
            inserted.trang_thai_TK,
            SUSER_SNAME(),
            GETDATE()
        FROM inserted 
        JOIN deleted ON inserted.TK_id = deleted.TK_id
        WHERE inserted.trang_thai_TK <> deleted.trang_thai_TK;
    END

    -- 6. Cột nguoidung_id
    IF UPDATE(nguoidung_id)
    BEGIN
        INSERT INTO table_log
        SELECT
            N'taikhoan',
            N'UPDATE',
            inserted.TK_id,
            N'nguoidung_id',
            ISNULL(deleted.nguoidung_id, N'NULL'),
            ISNULL(inserted.nguoidung_id, N'NULL'),
            SUSER_SNAME(),
            GETDATE()
        FROM inserted 
        JOIN deleted ON inserted.TK_id = deleted.TK_id
        WHERE ISNULL(inserted.nguoidung_id, '') <> ISNULL(deleted.nguoidung_id, '');
    END

    PRINT N'Đã ghi log các thay đổi trong bảng taikhoan vào table_log.';

END
go

-- Kiểm tra trigger 
UPDATE taikhoan
SET so_du = 999999
WHERE TK_id = 'TK000010';

-- Kiểm tra bảng log
SELECT * FROM table_log;

-- Tạo trigger after ghi log delete taikhoan
go
CREATE OR ALTER TRIGGER trigg_taikhoan_delete
ON taikhoan
AFTER DELETE
AS
BEGIN
    INSERT INTO table_log
    SELECT 
        N'taikhoan',                           -- Tên bảng
        N'DELETE',                             -- Loại thao tác
        deleted.TK_id,                         -- ID tài khoản bị xóa
        NULL,                                  -- DELETE -> không chỉ rõ cột
        -- old_value: mô tả tài khoản bị xóa
        N'Tài khoản bị xóa -> Tên đăng nhập: ' + deleted.ten_dang_nhap
            + N', Loại TK: ' + deleted.loai_TK
            + N', Trạng thái: ' + deleted.trang_thai_TK
            + N', Số dư: ' + CAST(deleted.so_du AS NVARCHAR(20))
            + N', Người dùng ID: ' + ISNULL(deleted.nguoidung_id, N'NULL'),
        NULL,                                  -- new_value = NULL khi DELETE
        SUSER_SNAME(),                         -- Người thực hiện
        GETDATE()                              -- Thời điểm
    FROM deleted;

    print N'Đã ghi log DELETE cho bảng taikhoan';
    
END
go

-- Kiểm tra trigger 
DELETE FROM taikhoan
WHERE TK_id = 'TK000041';

-- Kiểm tra bảng log
SELECT * FROM table_log;

-- 4.5.2 Ứng dụng trigger after để kiểm tra giới hạn chức vụ nhân viên
----------------------------------------------------------------------
-- Kiểm tra logic nghiệp vụ sau: Khi thêm, sửa dữ liệu vào bảng nhanvien chỉ được là "Nhân viên quầy" hoặc "Nhân viên phục vụ" hoặc "Nhân viên kỹ thuật"
go
CREATE OR ALTER TRIGGER trigg_nhanvien_check_chucvu
ON nhanvien
AFTER INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra chức vụ hợp lệ
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE LOWER(i.chuc_vu) NOT IN (
            N'nhân viên quầy',
            N'nhân viên kỹ thuật',
            N'nhân viên phục vụ'
        )
    )
    BEGIN
        ;THROW 50002, N'Chức vụ không hợp lệ. Chỉ được phép là: "Nhân viên quầy", "Nhân viên kỹ thuật" hoặc "Nhân viên phục vụ".', 1;
        ROLLBACK;
        RETURN;
    END
END
go

-- Kiểm tra trigger sai
UPDATE nhanvien
SET chuc_vu = N'Lập trình viên'
WHERE NV_id = 'NV001';

-- Kiểm tra trigger đúng
INSERT INTO nhanvien (NV_id, hoten, gioi_tinh, chuc_vu, ngay_sinh, sdt, dia_chi)
VALUES ('NV998', N'Hoàng Văn Đúng', N'Nam', N'Nhân viên quầy', '1997-05-10', '0988888888', N'Địa chỉ XYZ');

-- 4.5.3 Tạo trigger after kiểm tra độ dài mật khẩu tài khoản
-------------------------------------------------------------
-- Kiểm tra logic nghiệp vụ sau: Mật khẩu tài khoản người dùng không được quá 10 ký tự
go
CREATE OR ALTER TRIGGER trigg_taikhoan_check_matkhau
ON taikhoan
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @len INT;

    -- Lấy độ dài mật khẩu của các bản ghi mới hoặc cập nhật
    SELECT @len = MAX(LEN(mat_khau))
    FROM inserted;

    -- Kiểm tra mật khẩu quá 10 ký tự
    IF (@len > 10)
    BEGIN
        ;THROW 50003, N'Mật khẩu tài khoản không được vượt quá 10 ký tự.', 1;
        ROLLBACK;
        RETURN;
    END
END
go

-- Kiểm tra trigger sai
-----------------------
INSERT INTO taikhoan (TK_id, ten_dang_nhap, mat_khau, so_du, loai_TK, trang_thai_TK)
VALUES ('TK900001', '0901234567', '123456789012345', 0, N'Thường', N'Hoạt động');

-- Kiểm tra trigger đúng
------------------------
INSERT INTO taikhoan (TK_id, ten_dang_nhap, mat_khau, so_du, loai_TK, trang_thai_TK)
VALUES ('TK900002', '0908888888', 'abcd1234', 0, N'Thường', N'Hoạt động');

-- 4.5.4 Tạo trigger after kiểm soát số lượng nhân viên theo chức vụ
--------------------------------------------------------------------
-- Viết trigger after kiểm tra quy tắc nghiệp vụ dựa trên thống kê: Số lượng nhân viên theo chức vụ không được vượt quá giới hạn (nhân viên quầy <= 10, nhân viên phục vụ <= 6, nhân viên kỹ thuật <= 6)
go
CREATE OR ALTER TRIGGER trigg_nhanvien_check_chucvu
ON nhanvien
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE 
        @count_quay INT,
        @count_phucvu INT,
        @count_kithuat INT;

    -- Đếm số lượng thực tế sau khi thêm/sửa
    SELECT 
        @count_quay = COUNT(*) 
            FROM nhanvien WHERE chuc_vu = N'Nhân viên quầy';

    SELECT 
        @count_phucvu = COUNT(*) 
            FROM nhanvien WHERE chuc_vu = N'Nhân viên phục vụ';

    SELECT 
        @count_kithuat = COUNT(*) 
            FROM nhanvien WHERE chuc_vu = N'Nhân viên kỹ thuật';

    -- Kiểm tra giới hạn
    IF (@count_quay > 10)
    BEGIN
        THROW 50010, N'Số lượng Nhân viên quầy không được vượt quá 10.', 1;
        ROLLBACK;
        RETURN;
    END

    IF (@count_phucvu > 6)
    BEGIN
        THROW 50011, N'Số lượng Nhân viên phục vụ không được vượt quá 6.', 1;
        ROLLBACK;
        RETURN;
    END

    IF (@count_kithuat > 6)
    BEGIN
        THROW 50012, N'Số lượng Nhân viên kỹ thuật không được vượt quá 6.', 1;
        ROLLBACK;
        RETURN;
    END
END;
go

-- Kiểm tra trigger sai
UPDATE nhanvien
SET chuc_vu = N'Nhân viên phục vụ'
WHERE NV_id = 'NV005'; -- NV005 đang là Nhân viên kỹ thuật

-- Kiểm tra trigger đúng
INSERT INTO nhanvien (NV_id, hoten, gioi_tinh, chuc_vu, ngay_sinh, sdt, dia_chi)
VALUES ('NV022', N'Test NV Kỹ thuật', N'Nam', N'Nhân viên quầy', '2000-02-02', '0922222222', N'TP.HCM');

--4.5.5 Tạo trigger after kiểm tra trùng tài khoản thường đang hoạt động của người dùng
---------------------------------------------------------------------------------------
-- Mỗi người dùng chỉ được sở hữu duy nhất một tài khoản Thường đang hoạt động.
go
CREATE OR ALTER TRIGGER trigg_KiemTraTKNguoiDungHoatDong
ON taikhoan
AFTER INSERT, UPDATE
AS
BEGIN
    -- Chỉ kiểm tra các bản ghi loại tài khoản Thường và trạng thái Hoạt động
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN taikhoan t ON t.nguoidung_id = i.nguoidung_id
        WHERE 
            i.loai_TK = N'Thường'
            AND i.trang_thai_TK = N'Hoạt động'
            AND t.loai_TK = N'Thường'
            AND t.trang_thai_TK = N'Hoạt động'
            AND t.TK_id <> i.TK_id    -- không tính tài khoản đang insert/update
    )
    BEGIN
        RAISERROR 
        (N'Người dùng này đã có tài khoản Thường đang hoạt động. Không thể tạo thêm!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
go

-- Kiểm tra
INSERT INTO taikhoan (TK_id, ten_dang_nhap, mat_khau, so_du, loai_TK, trang_thai_TK, nguoidung_id)
VALUES ('TK000099', '0901111001', 'pass123', 10000, N'Thường', N'Hoạt động', 'ND000001');

-- 4.5.6 Ứng dụng trigger instead of để ngăn chặn dml trái phép và thủ tục khôi phục dữ liệu
--------------------------------------------------------------------------------------------
-- Tạo bảng ghi log cho các hành vi DML trái phép, chạy 1 lần duy nhất
drop table if exists dml_log_illegal;
create table dml_log_illegal (
    log_id INT IDENTITY(1,1) CONSTRAINT pk_dml_log_illegal PRIMARY KEY,
    table_name NVARCHAR(256) NOT NULL, -- Tên bảng bị thao tác trái phép
    record_id CHAR(20) NOT NULL, -- ID của bản ghi bị thao tác trái phép
    record_data NVARCHAR(MAX) NOT NULL, -- Dữ liệu của bản ghi bị thao tác trái phép, Nếu không có B3 thì bỏ qua bước này
    changed_by NVARCHAR(256) DEFAULT SUSER_SNAME(), -- Người thực hiện thao tác trái phép
    changed_date DATETIME DEFAULT GETDATE(), -- Thời gian thực hiện thao tác
    reason NVARCHAR(512) NULL, -- Lý do bị coi là trái phép
    restored_date DATETIME NULL, -- Thời gian khôi phục bản ghi nếu có, Nếu không có B3 thì bỏ qua bước này
    restored_by NVARCHAR(256) NULL -- Người khôi phục bản ghi nếu có, Nếu không có B3 thì bỏ qua bước này
);

-- 4.5.6.1 Tạo một TRIGGER INSTEAD OF INSERT trên bảng ct_hoadondichvu nhằm ngăn chặn hành vi thêm trái phép
go
CREATE OR ALTER TRIGGER trigg_ct_hoadondichvu_illegal_insert
ON ct_hoadondichvu
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @v_dvid CHAR(8);
    DECLARE @v_hdid CHAR(12);
    DECLARE @v_soluong INT;
    DECLARE @v_dongia MONEY;

    DECLARE @v_related TINYINT = 1;  -- Mặc định hợp lệ
    DECLARE @v_reason NVARCHAR(MAX);

    -- Lấy dữ liệu từ inserted (giả định 1 dòng)
    SELECT 
        @v_dvid = i.dichvuanuong_id,
        @v_hdid = i.hoadondichvu_id,
        @v_soluong = i.so_luong,
        @v_dongia = i.don_gia
    FROM inserted i;

    -- 1. Kiểm tra bảng dichvuanuong có tồn tại không
    IF NOT EXISTS (SELECT 1 FROM dichvuanuong WHERE dichvuanuong_id = @v_dvid)
    BEGIN
        SET @v_related = 0;
        SET @v_reason = N'Mã dịch vụ ăn uống không tồn tại -> Thêm trái phép.';
    END

    -- 2. Kiểm tra bảng hoadondichvu có tồn tại không
    IF NOT EXISTS (SELECT 1 FROM hoadondichvu WHERE hoadondichvu_id = @v_hdid)
    BEGIN
        SET @v_related = 0;
        SET @v_reason = N'Mã hóa đơn dịch vụ không tồn tại -> Thêm trái phép.';
    END

    -- 3. Kiểm tra số lượng > 0
    IF (@v_soluong IS NULL OR @v_soluong <= 0)
    BEGIN
        SET @v_related = 0;
        SET @v_reason = N'Số lượng phải > 0 -> Thêm trái phép.';
    END

    -- 4. Kiểm tra đơn giá hợp lệ
    IF (@v_dongia IS NULL OR @v_dongia <= 0)
    BEGIN
        SET @v_related = 0;
        SET @v_reason = N'Đơn giá không hợp lệ -> Thêm trái phép.';
    END

    -- 5. Nếu dữ liệu không hợp lệ -> Ghi log + Không cho insert
    IF @v_related = 0
    BEGIN
        INSERT INTO dml_log_illegal
        (
            table_name,
            record_id,
            record_data,
            reason
        )
        VALUES
        (
            'ct_hoadondichvu',
            @v_hdid,
            CONCAT(@v_dvid, ' | ', @v_hdid, ' | SL:', @v_soluong, ' | DG:', @v_dongia),
            @v_reason
        );

        PRINT N'Chèn ct_hoadondichvu bị chặn do dữ liệu không hợp lệ.';
        RETURN;
    END

    -- 6. Nếu hợp lệ -> Thực hiện INSERT chính thức
    INSERT INTO ct_hoadondichvu
    VALUES (@v_dvid, @v_hdid, @v_soluong, @v_dongia);

    PRINT N'Thêm chi tiết hóa đơn dịch vụ thành công.';
END;
go

-- Kiểm tra insert thành công, không ghi log trái phép 
INSERT INTO ct_hoadondichvu
VALUES ('DV020', 'HDDV00001', 2, 35000);

-- Kiểm tra insert thất bại, ghi log trái phép 
INSERT INTO ct_hoadondichvu
VALUES ('DV999', 'HDDV00001', 2, 35000);

INSERT INTO ct_hoadondichvu
VALUES ('DV001', 'HDDV99999', 2, 35000);

INSERT INTO ct_hoadondichvu
VALUES ('DV001', 'HDDV00001', 0, 35000);

-- Kiểm tra bảng log trái phép
SELECT * FROM dml_log_illegal;

-- 4.5.6.1 Tạo một trigger INSTEAD OF DELETE trên bảng dichvuanuong nhằm ngăn chặn hành vi xóa trái phép
go
CREATE OR ALTER TRIGGER trigg_dichvuanuong_illegal_delete
ON dichvuanuong
INSTEAD OF DELETE
AS
BEGIN
    DECLARE 
        @v_dichvuanuong_id CHAR(8),
        @v_ten_mon NVARCHAR(30),
        @v_loai_mon NVARCHAR(20),
        @v_don_gia DECIMAL(10,2),
        @v_NV_id CHAR(6),
        @v_related TINYINT = 0,
        @v_reason NVARCHAR(500);

    -- Lấy dữ liệu từ DELETED (giả sử chỉ xóa 1 dòng/lần)
    SELECT 
        @v_dichvuanuong_id = d.dichvuanuong_id,
        @v_ten_mon = d.ten_mon,
        @v_loai_mon = d.loai_mon,
        @v_don_gia = d.don_gia,
        @v_NV_id = d.NV_id
    FROM deleted d;

    -- 1. KIỂM TRA DỮ LIỆU LIÊN QUAN
    IF EXISTS (SELECT 1 
               FROM ct_hoadondichvu 
               WHERE dichvuanuong_id = @v_dichvuanuong_id)
    BEGIN
        SET @v_related = 1;
        SET @v_reason = N'Không thể xóa dịch vụ ăn uống vì đang được sử dụng trong hóa đơn dịch vụ.';
    END

    -- 2. Nếu liên quan → GHI LOG VÀ CHẶN XÓA
    IF @v_related = 1
    BEGIN
        INSERT INTO dml_log_illegal
        (
            table_name,
            record_id,
            record_data,
            changed_by,
            changed_date,
            reason,
            restored_date,
            restored_by
        )
        VALUES 
        (
            'dichvuanuong',
            @v_dichvuanuong_id,
            CONCAT(@v_ten_mon, ' | ', @v_loai_mon, ' | ', @v_don_gia, ' | NV:', COALESCE(@v_NV_id,'')),
            SUSER_SNAME(),
            GETDATE(),
            @v_reason,
            NULL,
            NULL
        );

        PRINT N'Không thể xóa dịch vụ ăn uống vì đang được sử dụng trong hóa đơn.';
        RETURN;
    END

    -- 3. Không có liên quan → GHI LOG + XÓA CHÍNH THỨC
    SET @v_reason = N'Xóa dịch vụ ăn uống thành công. Không có dữ liệu liên quan.';

    INSERT INTO dml_log_illegal
    (
        table_name,
        record_id,
        record_data,
        changed_by,
        changed_date,
        reason,
        restored_date,
        restored_by
    )
    VALUES 
    (
        'dichvuanuong',
        @v_dichvuanuong_id,
        CONCAT(@v_ten_mon, ' | ', @v_loai_mon, ' | ', @v_don_gia, ' | NV:', COALESCE(@v_NV_id,'')),
        SUSER_SNAME(),
        GETDATE(),
        @v_reason,
        NULL,
        NULL
    );

    DELETE FROM dichvuanuong
    WHERE dichvuanuong_id = @v_dichvuanuong_id;

    PRINT N'Đã xóa dịch vụ ăn uống thành công.';
END;
go

-- Xóa thất bại và ghi log trái phép
DELETE FROM dichvuanuong WHERE dichvuanuong_id = 'DV001';

-- Xóa thành công
INSERT INTO dichvuanuong (dichvuanuong_id, ten_mon, loai_mon, don_gia, NV_id) VALUES
('DV999', N'Mì xào trứng', N'Đồ ăn', 35000, 'NV004');

DELETE FROM dichvuanuong WHERE dichvuanuong_id = 'DV999';

-- Kiểm tra bảng log trái phép
SELECT * FROM dml_log_illegal;

-- 4.5.6.2 Viết 1 thủ tục cho phép khôi phục dữ liệu của bảng dichvuanuong
go
CREATE OR ALTER PROC usp_RestoreDichVuAnUong
    @p_dichvuanuong_id CHAR(8),
    @p_restore_reason NVARCHAR(MAX) = NULL
AS
BEGIN
    -- 1. Kiểm tra xem bản ghi có trong log và CHƯA được khôi phục không
    IF NOT EXISTS (
        SELECT 1 FROM dml_log_illegal
        WHERE table_name = 'dichvuanuong'
          AND record_id = @p_dichvuanuong_id
          AND restored_date IS NULL
    )
    BEGIN
        PRINT N'Dịch vụ ăn uống ' + @p_dichvuanuong_id 
              + N' không tồn tại trong log hoặc đã được khôi phục.';
        RETURN;
    END

    -- 2. Lấy record_data để phân tích thành các trường (tên, loại, giá, NV_id)
    DECLARE 
        @v_record_data NVARCHAR(MAX),
        @v_ten_mon NVARCHAR(30),
        @v_loai_mon NVARCHAR(20),
        @v_don_gia DECIMAL(10,2),
        @v_NV_id CHAR(6),
        @v_tmp NVARCHAR(MAX);

    SELECT @v_record_data = record_data
    FROM dml_log_illegal
    WHERE table_name = 'dichvuanuong'
      AND record_id = @p_dichvuanuong_id
      AND restored_date IS NULL;

    -- TÁCH tên món
    SET @v_ten_mon = SUBSTRING(@v_record_data, 1, CHARINDEX('|', @v_record_data) - 2);
    SET @v_tmp = SUBSTRING(@v_record_data, CHARINDEX('|', @v_record_data) + 2, LEN(@v_record_data));

    -- TÁCH loại món
    SET @v_loai_mon = SUBSTRING(@v_tmp, 1, CHARINDEX('|', @v_tmp) - 2);
    SET @v_tmp = SUBSTRING(@v_tmp, CHARINDEX('|', @v_tmp) + 2, LEN(@v_tmp));

    -- TÁCH đơn giá
    SET @v_don_gia = TRY_CAST(SUBSTRING(@v_tmp, 1, CHARINDEX('|', @v_tmp) - 2) AS DECIMAL(10,2));
    SET @v_tmp = SUBSTRING(@v_tmp, CHARINDEX('|', @v_tmp) + 2, LEN(@v_tmp));

    -- TÁCH NV_id (vd: NV:NV001)
    SET @v_NV_id = NULL;
    IF LEFT(@v_tmp, 3) = 'NV:'
        SET @v_NV_id = SUBSTRING(@v_tmp, 4, LEN(@v_tmp));

    -- 3. Khôi phục dữ liệu vào bảng dichvuanuong
    INSERT INTO dichvuanuong (dichvuanuong_id, ten_mon, loai_mon, don_gia, NV_id)
    VALUES (@p_dichvuanuong_id, @v_ten_mon, @v_loai_mon, @v_don_gia, @v_NV_id);

    PRINT N'Khôi phục dịch vụ ăn uống thành công.';

    -- 4. Cập nhật log: đánh dấu đã khôi phục
    UPDATE dml_log_illegal
    SET restored_date = GETDATE(),
        reason = @p_restore_reason,
        restored_by = SUSER_SNAME()
    WHERE table_name = 'dichvuanuong'
      AND record_id = @p_dichvuanuong_id
      AND restored_date IS NULL;
END;
go

-- Kiểm tra thủ tục khôi phục lại dữ liệu vừa xóa
EXEC usp_RestoreDichVuAnUong 
    @p_dichvuanuong_id = 'DV999',
    @p_restore_reason = N'Khôi phục do xóa nhầm';

-- Kiểm tra bảng dichvuanuong
select * from dichvuanuong
where dichvuanuong_id = 'DV999';

-- Kiểm tra bảng log trái phép
SELECT * FROM dml_log_illegal;

-- 4.5.7 Ứng dụng trigger instead of sử dụng trên view phức tạp(complex view)
-----------------------------------------------------------------------------
-- Tạo view phức tạp hiển thị thông tin tài khoản và người dùng
go
CREATE OR ALTER VIEW vw_ThongTinTaiKhoanNguoiDung
AS
SELECT 
    tk.TK_id,
    tk.ten_dang_nhap,
    tk.so_du,
    tk.loai_TK,
    tk.trang_thai_TK,
    nd.ho_ten,
    nd.sdt,
    nd.gioi_tinh,
    nd.ngay_sinh
FROM taikhoan tk
LEFT JOIN nguoidung nd
    ON tk.nguoidung_id = nd.nguoidung_id;
	go

-- Viết 1 trigger instead of insert  trên view vw_ThongTinTaiKhoanNguoiDung
CREATE OR ALTER TRIGGER trg_vw_ThongTinTaiKhoanNguoiDung_insert
ON vw_ThongTinTaiKhoanNguoiDung
INSTEAD OF INSERT
AS
BEGIN
    DECLARE 
        @v_TK_id CHAR(10),
        @v_ten_dang_nhap NVARCHAR(15),
        @v_so_du DECIMAL(10,2),
        @v_loai_TK NVARCHAR(20),
        @v_trang_thai_TK NVARCHAR(20),
        @v_ho_ten NVARCHAR(100),
        @v_sdt NVARCHAR(15),
        @v_gioi_tinh NVARCHAR(5),
        @v_ngay_sinh DATE,
        @v_nguoidung_id CHAR(10);

    -- Lấy dữ liệu từ inserted
    SELECT 
        @v_TK_id           = TK_id,
        @v_ten_dang_nhap   = ten_dang_nhap,
        @v_so_du           = so_du,
        @v_loai_TK         = loai_TK,
        @v_trang_thai_TK   = trang_thai_TK,
        @v_ho_ten          = ho_ten,
        @v_sdt             = sdt,
        @v_gioi_tinh       = gioi_tinh,
        @v_ngay_sinh       = ngay_sinh
    FROM inserted;

    -- 1. XỬ LÝ NGƯỜI DÙNG

    -- nếu số điện thoại đã tồn tại -> lấy luôn ID
    SELECT @v_nguoidung_id = nguoidung_id 
    FROM nguoidung 
    WHERE sdt = @v_sdt;

    -- nếu chưa tồn tại → tạo mã mới & insert
    IF @v_nguoidung_id IS NULL
    BEGIN
        DECLARE @nextND INT = (
            SELECT ISNULL(MAX(CAST(SUBSTRING(nguoidung_id, 3, 8) AS INT)), 0) + 1
            FROM nguoidung
        );

        SET @v_nguoidung_id = 'ND' + RIGHT('000000' + CAST(@nextND AS VARCHAR(6)), 6);

        INSERT INTO nguoidung(nguoidung_id, ho_ten, gioi_tinh, ngay_sinh, sdt)
        VALUES (@v_nguoidung_id, @v_ho_ten, @v_gioi_tinh, @v_ngay_sinh, @v_sdt);
    END

    -- 2. XỬ LÝ TÀI KHOẢN

    -- Nếu TK_id NULL hoặc chưa tồn tại → tạo mã mới
    IF @v_TK_id IS NULL OR NOT EXISTS(SELECT 1 FROM taikhoan WHERE TK_id = @v_TK_id)
    BEGIN
        DECLARE @nextTK INT = (
            SELECT ISNULL(MAX(CAST(SUBSTRING(TK_id, 3, 8) AS INT)), 0) + 1
            FROM taikhoan
        );

        SET @v_TK_id = 'TK' + RIGHT('000000' + CAST(@nextTK AS VARCHAR(6)), 6);

        INSERT INTO taikhoan(
            TK_id, ten_dang_nhap, mat_khau, so_du, loai_TK, trang_thai_TK, nguoidung_id
        )
        VALUES (
            @v_TK_id, 
            @v_ten_dang_nhap,
            'default123',       -- mật khẩu mặc định khi tạo tài khoản mới
            @v_so_du,
            @v_loai_TK,
            @v_trang_thai_TK,
            @v_nguoidung_id
        );
    END
END

-- Kiểm tra insert
INSERT INTO vw_ThongTinTaiKhoanNguoiDung
(TK_id, ten_dang_nhap, so_du, loai_TK, trang_thai_TK, ho_ten, sdt, gioi_tinh, ngay_sinh)
VALUES
(NULL, '0909999999', 50000, N'Thường', N'Hoạt động', 
 N'Nguyễn Khánh Hòa', '0909999999', N'Nam', '2001-10-10');

 -- Kiểm tra bảng sau khi insert
SELECT * FROM nguoidung WHERE sdt = '0909999999';
SELECT * FROM taikhoan WHERE ten_dang_nhap = '0909999999';

-- 4.5.8 Tạo trigger instead of insert tự động sinh ID cho các bảng
-------------------------------------------------------------------
-- Trigger tự tăng ID cho bảng nguoidung – NDxxxxxx
go
CREATE OR ALTER TRIGGER trigg_nguoidung_autoID
ON nguoidung
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @next INT;
    DECLARE @newID CHAR(10);

    -- Lấy số lớn nhất
    SELECT @next = ISNULL(MAX(CAST(SUBSTRING(nguoidung_id, 3, 6) AS INT)), 0) + 1
    FROM nguoidung;

    -- Sinh mã NDxxxxxx
    SET @newID = 'ND' + RIGHT('000000' + CAST(@next AS VARCHAR(6)), 6);

    INSERT INTO nguoidung(nguoidung_id, ho_ten, gioi_tinh, ngay_sinh, sdt)
    SELECT @newID, ho_ten, gioi_tinh, ngay_sinh, sdt
    FROM inserted;
END
go

-- Trigger tự tăng ID cho bảng taikhoan – TKxxxxxx
CREATE OR ALTER TRIGGER trigg_taikhoan_autoID
ON taikhoan
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @next INT;
    DECLARE @newID CHAR(10);

    SELECT @next = ISNULL(MAX(CAST(SUBSTRING(TK_id, 3, 6) AS INT)), 0) + 1
    FROM taikhoan;

    SET @newID = 'TK' + RIGHT('000000' + CAST(@next AS VARCHAR(6)), 6);

    INSERT INTO taikhoan(TK_id, ten_dang_nhap, mat_khau, so_du, loai_TK, trang_thai_TK, nguoidung_id)
    SELECT @newID, ten_dang_nhap, mat_khau, so_du, loai_TK, trang_thai_TK, nguoidung_id
    FROM inserted;
END

-- Trigger tự tăng ID cho bảng nhanvien – NVxxx
go
CREATE OR ALTER TRIGGER trigg_nhanvien_autoID
ON nhanvien
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @next INT;
    DECLARE @newID CHAR(6);

    SELECT @next = ISNULL(MAX(CAST(SUBSTRING(NV_id, 3, 3) AS INT)), 0) + 1
    FROM nhanvien;

    SET @newID = 'NV' + RIGHT('000' + CAST(@next AS VARCHAR(3)), 3);

    INSERT INTO nhanvien(NV_id, hoten, gioi_tinh, chuc_vu, ngay_sinh, sdt, dia_chi)
    SELECT @newID, hoten, gioi_tinh, chuc_vu, ngay_sinh, sdt, dia_chi
    FROM inserted;
END
GO

-- Trigger tự tăng ID cho bảng taikhoannhanvien – TKNVxxx
CREATE OR ALTER TRIGGER trigg_taikhoannhanvien_autoID
ON taikhoannhanvien
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @next INT;
    DECLARE @newID CHAR(10);

    SELECT @next = ISNULL(MAX(CAST(SUBSTRING(TKNV_id, 5, 3) AS INT)), 0) + 1
    FROM taikhoannhanvien;

    SET @newID = 'TKNV' + RIGHT('000' + CAST(@next AS VARCHAR(3)), 3);

    INSERT INTO taikhoannhanvien(TKNV_id, ten_dang_nhap_NV, mat_khau, ngay_tao, NV_id)
    SELECT @newID, ten_dang_nhap_NV, mat_khau, ngay_tao, NV_id
    FROM inserted;
END

-- Kiểm tra
INSERT INTO nguoidung (ho_ten, gioi_tinh, ngay_sinh, sdt)
VALUES (N'Uyên Nhi', N'Nữ', '2005-11-01', '0852854588');

INSERT INTO taikhoan (ten_dang_nhap, mat_khau, so_du, loai_TK, trang_thai_TK, nguoidung_id)
VALUES ('0000000000', '123', 0, N'Tạm thời', N'Hoạt động', NULL);

-- Xem dữ liệu vừa thêm
select * from nguoidung 
where ho_ten = N'Uyên Nhi';

select * from taikhoan
where mat_khau = '123';

--4.5.9 Tạo trigger instead of delete trên bảng nhanvien để chặn xóa và khóa dữ liệu khi nghỉ việc 
--------------------------------------------------------------------------------------------------
-- Thêm trạng thái cho nhân viên
ALTER TABLE nhanvien
ADD trang_thai_NV NVARCHAR(20) DEFAULT N'Hoạt động';
-- Thêm trạng thái cho tài khoản nhân viên
ALTER TABLE taikhoannhanvien
ADD trang_thai_TKNV NVARCHAR(20) DEFAULT N'Hoạt động';
-- Tạo trigger
GO
-- Trigger chặn xóa (INSTEAD OF DELETE)
CREATE OR ALTER TRIGGER trigg_KhoaTKNhanVien_Delete
ON nhanvien
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Lấy danh sách NV_id bị xóa
    DECLARE @AffectedNV TABLE (NV_id CHAR(6));
    INSERT INTO @AffectedNV (NV_id)
    SELECT NV_id FROM deleted;

    -- Đánh dấu nhân viên nghỉ việc (soft delete)
    UPDATE nhanvien
    SET trang_thai_NV = N'Đã nghỉ việc'
    WHERE NV_id IN (SELECT NV_id FROM @AffectedNV);

    -- Khóa tài khoản nhân viên tương ứng
    UPDATE taikhoannhanvien
    SET trang_thai_TKNV = N'Khóa'
    WHERE NV_id IN (SELECT NV_id FROM @AffectedNV);

    PRINT N'Nhân viên không được xóa, tự động chuyển trạng thái "Đã nghỉ việc".';
END;

-- Kiểm tra trigger
DELETE FROM nhanvien
WHERE NV_id = 'NV004';

-- Kiểm tra bảng
select * from nhanvien
where trang_thai_NV = N'Đã nghỉ việc';

select * from taikhoannhanvien
where trang_thai_TKNV = N'Khóa';

-- 4.5.10 Ứng dụng trigger DDL ghi log thay đổi cấu trúc cơ sở dữ liệu
----------------------------------------------------------------------
-- Tạo bảng DDL_log
DROP TABLE IF EXISTS DDL_log;
CREATE TABLE DDL_log(
    log_id INT IDENTITY(1,1) CONSTRAINT PK_DDL_log PRIMARY KEY,
    EventTime DATETIME DEFAULT GETDATE(), -- Thời gian xảy ra sự kiện
    EventType NVARCHAR(50), -- Loại sự kiện (CREATE, ALTER, DROP)
    DatabaseName NVARCHAR(255), -- Tên cơ sở dữ liệu
    SchemaName NVARCHAR(255), -- Tên schema
    ObjectName NVARCHAR(255), -- Tên đối tượng (bảng, view, procedure, v.v.)
    ObjectType NVARCHAR(50), -- Loại đối tượng (TABLE, VIEW, PROCEDURE, v.v.)
    TSQLCommand NVARCHAR(MAX), -- Câu lệnh T-SQL đã thực thi
    ExecutedBy NVARCHAR(255) DEFAULT SUSER_SNAME(), -- Người thực thi câu lệnh
    ActionStatus NVARCHAR(50) DEFAULT 'SUCCESS', -- Trạng thái hành động (SUCCESS, FAILURE)
    EventXML XML NULL
);

-- Viết Trigger DDL để ghi log
go
create or alter trigger trigg_ddl_log
ON database
for create_table, alter_table, drop_table,
    create_view, alter_view, drop_view,
    create_procedure, alter_procedure, drop_procedure,
    create_function, alter_function, drop_function,
    create_index, alter_index, drop_index,
    create_trigger, alter_trigger, drop_trigger
as
BEGIN
    DECLARE @EventData XML = EVENTDATA(); -- Lấy dữ liệu sự kiện DDL dưới dạng XML
    DECLARE @EventType NVARCHAR(100) = @EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)');
    DECLARE @DatabaseName NVARCHAR(100) = @EventData.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'NVARCHAR(100)');
    DECLARE @SchemaName NVARCHAR(100) = @EventData.value('(/EVENT_INSTANCE/SchemaName)[1]', 'NVARCHAR(100)');
    DECLARE @ObjectName NVARCHAR(100) = @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)');
    DECLARE @ObjectType NVARCHAR(100) = @EventData.value('(/EVENT_INSTANCE/ObjectType)[1]', 'NVARCHAR(100)');
    DECLARE @TSQLCommand NVARCHAR(MAX) = @EventData.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(MAX)');
    DECLARE @ExcutedBy NVARCHAR(100) = ORIGINAL_LOGIN();
    DECLARE @EventTime DATETIME = GETDATE();

    BEGIN TRY
        INSERT INTO DDL_log 
        VALUES(
            @EventTime,
            @EventType,
            @DatabaseName,
            @SchemaName,
            @ObjectName,
            @ObjectType,
            @TSQLCommand,
            @ExcutedBy,
            N'Success',
            @EventData
        );

        PRINT N'Log DDL event recorded successfully.';
    END TRY
    BEGIN CATCH
        INSERT INTO DDL_log 
        VALUES (
            @EventTime,
            N'Lỗi khi ghi log DDL',
            @DatabaseName,
            NULL,
            NULL,
            NULL,
            N'Lỗi: ' + ERROR_MESSAGE(),
            @ExcutedBy,
            N'FAILURE',
            NULL
        );
    END CATCH
END
go

-- Kiểm tra thêm sửa xóa bảng
CREATE TABLE test_log(id INT);

ALTER TABLE test_log ADD name NVARCHAR(50);

DROP TABLE test_log;

-- Xem bảng log DDL
select * from ddl_log;

-- 4.5.11 Ứng dụng Trigger DDL để ngăn chặn thay đổi cấu trúc CSDL
------------------------------------------------------------------
--Viết Trigger để ngăn chặn hành vi xóa bảng hoadonnaptien
go
CREATE OR ALTER TRIGGER trigg_prevent_delete_hoadonnaptien
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
    DECLARE @EventData XML = EVENTDATA(); -- Lấy dữ liệu sự kiện DDL dưới dạng XML
    DECLARE @EventType NVARCHAR(100) = @EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)');
    DECLARE @DatabaseName NVARCHAR(100) = @EventData.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'NVARCHAR(100)');
    DECLARE @SchemaName NVARCHAR(100) = @EventData.value('(/EVENT_INSTANCE/SchemaName)[1]', 'NVARCHAR(100)');
    DECLARE @ObjectName NVARCHAR(100) = @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)');
    DECLARE @ObjectType NVARCHAR(100) = @EventData.value('(/EVENT_INSTANCE/ObjectType)[1]', 'NVARCHAR(100)');
    DECLARE @TSQLCommand NVARCHAR(MAX) = @EventData.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(MAX)');
    DECLARE @ExecutedBy NVARCHAR(100) = SUSER_SNAME();
    DECLARE @EventTime DATETIME = GETDATE();

    -- Nếu đối tượng bị DROP đúng là hoadonnaptien → chặn
    IF @ObjectName = 'hoadonnaptien'
    BEGIN
        ROLLBACK; -- Hủy lệnh xóa bảng
        PRINT N'Xóa bảng hoadonnaptien bị ngăn chặn bởi trigger trigg_prevent_delete_hoadonnaptien.';

        -- Ghi log vào DDL_log
        INSERT INTO DDL_log
        VALUES(
            @EventTime,
            @EventType,
            @DatabaseName,
            @SchemaName,
            @ObjectName,
            @ObjectType,
            N'Xóa bảng hoadonnaptien bị ngăn chặn bởi trigger trigg_prevent_delete_hoadonnaptien.',
            @ExecutedBy,
            N'FAILURE',
            NULL
        );
    END
END

-- Kiểm tra
DROP TABLE hoadonnaptien;

-- Kiểm tra bảng DDL log
select * from DDL_log;
