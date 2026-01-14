If not exists ( Select * from sys.databases where name = 'Quanlykho')
create Database Quanlykho ; 
GO 
Use QuanlyKho;
----------------------------------
---KHAI BÁO MASTER DATA ------------
----------------------------------
create table CongTy 
(
    MaCT int Primary key identity (1,1) , 
    TenCT Nvarchar(100) , 
    MST varchar(13) not null , 
    DiaChi nvarchar(255) , 
    Tinh nvarchar(100), 
    CONSTRAINT DodaiMST CHECK (LEN(MST) = 10 OR LEN(MST) = 13)
); 
GO
Create table NhanVien 
(
    MaNV INT primary key identity (1,1) , 
    MaCT int not null,  
    TenNV Nvarchar(100) , 
    CCCD char(12), 
    Email nvarchar(255), 
    DiaChi nvarchar(255) , 
    Tinh nvarchar(100) , 
    Chucvu nvarchar(100) , 
    Constraint FK_NV_MaCT FOREIGN KEY(MaCT) REFERENCES CongTy(MaCT)
);
GO
create table LoaiKho 
( 
    MaLK int primary key IDENTITY (1,1),  
    TenLK Nvarchar(100) 
) ; 
GO
Create table Kho 
(
    MaKho INT primary key identity(1,1) , 
    MaCT INT NOT NULL ,
    MaLK INT NOT NULL ,
    MaQL INT NOT NULL , 
    TenKho nvarchar(100), 
    DiaChi nvarchar (255) , 
    Tinh nvarchar(50) , 
    TrangThaiKho BIT not null ,
    constraint FK_KHO_MaCT FOREIGN KEY(MaCT) REFERENCES CongTy(MaCT),
    constraint FK_KHO_MaLK FOREIGN KEY(MaLK) REFERENCES LoaiKho(MaLK),
    constraint FK_KHO_MaNV FOREIGN KEY(MaQL) REFERENCES NhanVien(MaNV),
    CONSTRAINT LoaiTrangThaiKho CHECK (TrangThaiKho IN (0,1))
);
GO 
create table LOAIKHUVUC  
(
    MaLKV varchar(5) primary key , 
    TenLKV  nvarchar(255) , 
    MoTa nvarchar(255) 
); 
GO
Create table KhuVuc 
(
    MaKV VARCHAR(5) PRIMARY KEY,
    TenKV NVARCHAR(255),
    MaKho INT NOT NULL,
    MaLKV VARCHAR(5) NOT NULL,
    MoTa NVARCHAR(255),
    CONSTRAINT FK_KhuVuc_Kho FOREIGN KEY (MaKho) REFERENCES Kho(MaKho), 
    CONSTRAINT FK_KhuVuc_LoaiKV FOREIGN KEY (MaLKV) REFERENCES LoaiKhuVuc(MaLKV)
); 
GO
Create Table ViTri 
(
    MaViT varchar(10) primary key , 
    MaKV Varchar(5) not null, 
    Dãy Varchar(5) , 
    Ô varchar(5), 
    MoTa NVARCHAR(255),
	DungTich decimal , 
    CONSTRAINT FK_ViTri_KhuVuc FOREIGN KEY (MaKV) REFERENCES KhuVuc(MaKV)
); 
GO
Create table Donvi 
(
    MaDonVi int Primary Key identity (1,1) , 
    TenDonVi nvarchar(255) , 
	Ký hiệu nvarchar(5) ,
    TinhTrang bit , 
 Constraint TK_DV CHECK ( TinhTrang = 0 or TinhTrang =  1 ) 
); 
GO
Create table LoaiVattu 
(
    MaLoai INT PRIMARY KEY IDENTITY(1,1) , 
    TenLoai nvarchar(255) 
); 
GO
Create Table VatTu 
(
    MaVatTu Int primary Key identity (1,1), 
    MaLoai Int not null, 
    MaDonVi int not null , 
    TenVattu nvarchar(255), 
    TinhtrangVT bit ,
    CONSTRAINT FK_MaL_VT foreign key ( MaLoai) REFERENCES LoaiVattu (MaLoai),
    CONSTRAINT DV_VT foreign key (MaDonVi) REFERENCES DonVi(MaDonVi),
    CONSTRAINT FK_TT_VT CHECK( TinhtrangVT = 0 OR TinhtrangVT = 1) 
); 
GO
Create table KhachHang 
(
    MaKH INT PRIMARY Key identity(1,1), 
    MaCT INT NOT NULL , 
    TenKH NVARCHAR(100), 
    MST char(10) not null , 
    Email varchar(255), 
    Tinhtrang bit , 
   Diachi nvarchar(255) , 
    CONSTRAINT FK_MaCT_KH FOREIGN KEY (MaCT) REFERENCES CongTy (MaCT) , 
    Constraint FK_SLMST_KH CHECK ( LEN(MST) = 10 OR LEN (MST) =13), 
    CONSTRAINT FK_TT_KH CHECK ( Tinhtrang = 0 or Tinhtrang = 1) 
); 
GO
Create table NCC 
(
    MaNCC INT PRIMARY Key identity(1,1), 
    MaCT INT NOT NULL , 
    TenNCC NVARCHAR(100), 
    MST char(10) not null , 
    Email varchar(255), 
    Tinhtrang bit , 
    Diachi nvarchar(255) , 
    CONSTRAINT FK_MaCT_NCC FOREIGN KEY (MaCT) REFERENCES CongTy (MaCT) , 
    Constraint FK_SLMST_NCC CHECK ( LEN(MST) = 10 OR LEN (MST) =13), 
    CONSTRAINT FK_TT_NCC CHECK ( Tinhtrang = 0 or Tinhtrang = 1) 
);
GO
----------------------------------
---NGHIỆP VỤ XUẤT KHO VÀ CHUYỂN KHO NỘI BỘ ------------
----------------------------------
CREATE TABLE DanhsachSO (
    SO_ID  INT IDENTITY PRIMARY KEY,
    MaKH INT NOT NULL,
    MaKho INT NOT NULL,
	MaCT INT NOT NULL , 
    NgayDat DATE,
    NgayGiao DATE,
    TrangThai NVARCHAR(20), 
    GiaTri  DECIMAL,  
	CONSTRAINT FK_MKH_SO FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH) , 
	CONSTRAINT FK_MaCT_SO FOREIGN KEY (MACT) REFERENCES CongTY(MaCT) , 
    CONSTRAINT FK_MaK_SO FOREIGN KEY (MaKho) REFERENCES Kho(MaKho) , 
	Constraint TT_SO CHECK ( TrangThai in (N'Nháp', N'Đã Xác nhận', N'Đã Hủy', N'Đã Hoàn Thành'))
	)
GO
CREATE TABLE DanhsachSOChiTiet (
    SO_ID INT NOT NULL,              
    MaVatTu INT NOT NULL,            
    SoLuong INT NOT NULL,            
    DonGia Decimal NOT NULL,             
    GiaTri AS (SoLuong * DonGia) PERSISTED, 
    CONSTRAINT PK_SOChiTiet PRIMARY KEY (SO_ID, MaVatTu),
    CONSTRAINT FK_SOChiTiet_SO FOREIGN KEY (SO_ID) REFERENCES DanhsachSO(SO_ID),
    CONSTRAINT FK_SOChiTiet_VatTu FOREIGN KEY (MaVatTu) REFERENCES VatTu(MaVatTu)
);
GO
Create table PhieuDieuChuyenKho (
    MaPDC Varchar(100) Primary key , 
	MaKhoNguon int not null, 
	MaKhoDich int not null, 
	MaNV int not null , 
	NgayLap date not null, 
	GiaTri  DECIMAL, 
	TrangThai Nvarchar(100) default N'Chờ xử lý' , 
	Lydo nvarchar(500) 
	Constraint FK_MaKN_PDC foreign key (MaKhoNguon) references Kho(MaKho), 
	Constraint FK_MaKD_PDC foreign key (MaKhoDich) references Kho(MaKho), 
	Constraint FK_MaNV_PDC foreign key (MaNV) references NhanVien (MaNV) , 
	Constraint Check_TT_PDC check (TrangThai in (N'Chờ xử lý', N'Đang chuyển', N'Đã hoàn thành', N'Đã Hủy'))
) ; 
GO
Create table PhieuDieuChuyenKhoChiTiet (
    MaPDC Varchar(100) not null  , 
	MaVatTu int not null , 
	Vitrixuat varchar(10) not null , 
	Vitrinhan varchar(10) not null , 
	Soluong int not null , 
	DonGia Decimal NOT NULL,   
	GiaTri AS (SoLuong * DonGia) PERSISTED
	Constraint PK_TH_PDCCT Primary key ( MaPDC, MaVatTu, Vitrixuat , Vitrinhan ) , 
	Constraint FK_PNC_PDCKCT Foreign key ( MaPDC) References PhieuDieuChuyenKho (MaPDC) , 
	Constraint FK_MVT_PDCKCT Foreign key ( MaVatTu) References VatTu (MaVatTu) ,
	Constraint FK_VTX_PDCKCT Foreign key ( Vitrixuat) References ViTri (MaViT) ,
	Constraint FK_VTN_PDCKCT Foreign key ( Vitrinhan) References ViTri (MaViT) ,
); 
GO
Create table PhieuLayHang (
    MaPLH int identity (1,1) primary key ,
	MaKho int not null ,
    MaNV int ,
	LoaiPhieu nvarchar(50) , 
	MaSO int  ,
	MaPDC varchar(100) , 
    NgayTao datetime ,
    NgayBatDau datetime ,
    NgayHoanThanh datetime ,
    TrangThai nvarchar(20) default N'Chờ Xử Lý' ,
    Constraint FK_PLH_SO foreign key (MaSO) references DanhsachSO(SO_ID) ,
	Constraint FK_PLH_PDC foreign key (MaPDC) references PhieuDieuChuyenKho(MaPDC) ,
    Constraint FK_PLH_Kho foreign key (MaKho) references Kho(MaKho) ,
    Constraint FK_PLH_NV foreign key (MaNV) references NhanVien(MaNV) ,
    Constraint CK_PLH_TT check (TrangThai in (N'Chờ Xử Lý', N'Đang lấy hàng', N'Đã Hoàn Thành', N'Đã Hủy')),
	Constraint CHECK_PLH_LP check ( (LoaiPhieu = 'PDC' and MaPDC IS NOT NULL AND MaSO is null ) or (LoaiPhieu = 'SO' and MaPDC IS  NULL AND MaSO is NOT null))
) ;
GO
Create table PhieuLayHangChiTiet (
    MaPLH int not null ,
    MaVatTu int not null ,
    MaViTri varchar(10) not null ,
    SoLuongYeuCau int not null ,
    SoLuongThucTe int ,
    ThuTuPick int ,
    Constraint PK_PLHCT primary key (MaPLH, MaVatTu, MaViTri) ,
       CONSTRAINT FK_PLHCT_PLH foreign key (MaPLH) references PhieuLayHang(MaPLH) ,
    Constraint FK_PLHCT_VatTu foreign key (MaVatTu) references VatTu(MaVatTu) ,
    Constraint FK_PLHCT_ViTri foreign key (MaViTri) references ViTri(MaViT)
) ;
GO
Create table PhieuDongGoi (
    MaPDG varchar(100) primary key ,
    MaPLH int not null ,
    MaNV int not null ,
    NgayDongGoi datetime default getdate() ,
    TrangThai nvarchar(20) ,
    Constraint FK_PDG_PLH foreign key (MaPLH ) references PhieuLayHang(MaPLH) ,
    Constraint FK_PDG_NV foreign key (MaNV) references NhanVien(MaNV)
) ;
GO
Create table PhieuXuatKho
(
    MaPXK varchar(100) primary key , 
    MaKho int not null , 
    MaNV int not null ,
    NgayLap date ,
    TongGia Decimal , 
    TrangThai NVARCHAR(50) NOT NULL DEFAULT N'Nháp',
    CONSTRAINT FK_MaKho_PXK  FOREIGN KEY (MaKho) REFERENCES Kho(MaKho) ,
    CONSTRAINT CK_PXK_TrangThai CHECK (TrangThai IN (N'Nháp', N'Đã Xác nhận', N'Đã Hủy', N'Đã Hoàn Thành')), 
    constraint FK_MaNV_PXK Foreign key (MaNV) REFERENCES NhanVien(MaNV) 
) ;
GO
Create table PhieuXuatKhoChiTiet
(
    MaPXK varchar(100) not null , 
    MaVatTu int not null ,
    MaKH int not null , 
    MaViT varchar(10) not null ,
    DonGia decimal not null , 
    Soluong int not null  ,
    GiaTri int not null , 
    CONSTRAINT FK_MaVT_PXKCT  FOREIGN KEY (MaVattu) REFERENCES VatTu (MaVattu) , 
    CONSTRAINT FK_MaPNK_PXKCT  FOREIGN KEY (MaPXK) REFERENCES PhieuXuatKho(MaPXK) , 
    CONSTRAINT FK_MaNCC_PXKCT  FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH) , 
    CONSTRAINT FK_PNKCT_ViT FOREIGN KEY (MaViT) REFERENCES ViTri(MaViT)
) ;
GO
----------------------------------
---NGHIỆP VỤ NHẬP KHO ------------
----------------------------------
Create table DanhsachPO 
(
    PO_ID INT PRIMARY KEY IDENTITY(1,1) , 
    MaCT INT NOT NULL , 
    MaKho INT NOT NULL, 
    MaNCC INT NOT NULL , 
    Ngay datetime , 
    CONSTRAINT FK_MaCT_PO FOREIGN KEY (MACT) REFERENCES CongTY(MaCT) , 
    CONSTRAINT FK_NCC_PO foreign key (MaNCC) REFERENCES NCC(MaNCC) ,  
    CONSTRAINT FK_MaK_PO FOREIGN KEY (MaKho) REFERENCES Kho(MaKho) 
); 
GO
CREATE TABLE DanhsachPOChiTiet (
    PO_ID INT NOT NULL,              
    MaVatTu INT NOT NULL,            
    SoLuong INT NOT NULL,            
    DonGia Decimal NOT NULL,             
    GiaTri AS (SoLuong * DonGia) PERSISTED, 
    CONSTRAINT PK_POChiTiet PRIMARY KEY (PO_ID, MaVatTu),
    CONSTRAINT FK_POChiTiet_PO FOREIGN KEY (PO_ID) REFERENCES DanhsachPO(PO_ID),
    CONSTRAINT FK_POChiTiet_VatTu FOREIGN KEY (MaVatTu) REFERENCES VatTu(MaVatTu)
); 
GO
Create Table Danhsachtrahang 
( MaPTH INT IDENTITY (1,1) PRIMARY KEY , 
  SO_ID int not null , 
  MaKH int not null , 
  MaKho int not null , 
  Ngaytao datetime, 
  Lydo nvarchar(255) , 
  Constraint FK_SO_PTH FOREIGN KEY (SO_ID) references DanhSachSO (SO_ID) , 
  Constraint FK_KH_PTH  foreign key (MaKH) references KhachHang (MaKH) , 
  Constraint FK_MK_PTH foreign key (MaKho) references Kho(MaKho) 
 ) ; 
 GO
Create TABLE PhieutrahangChiTiet 
(
    MaPTH  INT NOT NULL,
    MaVatTu INT NOT NULL, 
    DonGia Decimal,
    SoLuong INT,
    GiaTri AS (DonGia * SoLuong) PERSISTED,
    CONSTRAINT PK_PNKCT PRIMARY KEY (MaPTH, MaVatTu),
    CONSTRAINT FK_MaVT_PTHCT FOREIGN KEY (MaVatTu) REFERENCES VatTu(MaVatTu),
    CONSTRAINT FK_MaPTH_PTHCT FOREIGN KEY (MaPTH) REFERENCES Danhsachtrahang(MaPTH)
);
GO
Create Table PhieuNhapKho 
( 
    MaPNK varchar(100) primary key , 
    MaKho int not null , 
    NgayLap date ,
    TongGia decimal  ,
    MaNV int not null , 
    TrangThai NVARCHAR(50) NOT NULL DEFAULT N'Nháp',
    CONSTRAINT FK_MaKho_PNK  FOREIGN KEY (MaKho) REFERENCES Kho(MaKho) ,
    CONSTRAINT CK_PNK_TrangThai CHECK (TrangThai IN (N'Nháp', N'Đã Xác nhận', N'Đã Hủy', N'Đã Hoàn Thành')),
    constraint FK_MaNV_PNK Foreign key (MaNV) REFERENCES NhanVien(MaNV) 
);  
GO
Create TABLE PhieuNhapKhoChiTiet 
(
    MaPNK VARCHAR(100) NOT NULL,
    MaVatTu INT NOT NULL,
    MaNCC INT NOT NULL,
	MaViT VARCHAR(10) NOT NULL, 
    DonGia Decimal,
    SoLuong INT,
    GiaTri AS (DonGia * SoLuong) PERSISTED,
    CONSTRAINT PK_PNKCT1 PRIMARY KEY (MaPNK, MaVatTu),
    CONSTRAINT FK_MaVT_PNKCT FOREIGN KEY (MaVatTu) REFERENCES VatTu(MaVatTu),
    CONSTRAINT FK_MaPNK_PNKCT FOREIGN KEY (MaPNK) REFERENCES PhieuNhapKho(MaPNK),
    CONSTRAINT FK_MaNCC_PNKCT FOREIGN KEY (MaNCC) REFERENCES NCC(MaNCC), 
	CONSTRAINT FK_PNKCT_ViTri FOREIGN KEY (MaViT) REFERENCES ViTri(MaViT)
);
GO 

----------------------------------
---NGHIỆP VỤ TỒN KHO -------------
-----------------------------------
CREATE TABLE TonKhoVatTu (
    MaVatTu INT NOT NULL,
    MaKho   INT NOT NULL,
    SoLuong INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_TonKhoVatTu PRIMARY KEY (MaVatTu, MaKho),
    CONSTRAINT FK_TonKhoVatTu_VatTu FOREIGN KEY (MaVatTu) REFERENCES VatTu(MaVatTu),
    CONSTRAINT FK_TonKhoVatTu_Kho FOREIGN KEY (MaKho) REFERENCES Kho(MaKho)
);
GO
CREATE TABLE TonKhoChiTiet (
    MaVatTu INT NOT NULL,
    MaViTri VARCHAR(10) NOT NULL,
    MaKho INT NOT NULL,
    SoLuong INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_TonKhoChiTiet PRIMARY KEY (MaVatTu, MaViTri),
    CONSTRAINT FK_TonKhoChiTiet_VatTu FOREIGN KEY (MaVatTu) REFERENCES VatTu(MaVatTu),
    CONSTRAINT FK_TonKhoChiTiet_ViTri FOREIGN KEY (MaViTri) REFERENCES ViTri(MaViT),
    CONSTRAINT FK_TonKhoChiTiet_Kho FOREIGN KEY (MaKho) REFERENCES Kho(MaKho)
); 
GO
----------------------------------
---NGHIỆP VỤ KIỂM KÊ -------------
-----------------------------------
CREATE TABLE PhieuKiemKe (
    MaPKK INT PRIMARY KEY IDENTITY(1,1),
    MaKho INT NOT NULL,
    NgayKiemKe DATE NOT NULL,
    MaNV INT NOT NULL,
    TrangThai NVARCHAR(20) DEFAULT N'Chờ duyệt',
    CONSTRAINT FK_PKK_Kho FOREIGN KEY (MaKho) REFERENCES Kho(MaKho),
    CONSTRAINT FK_PKK_NV FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV), 
	CONSTRAINT CHECK_TT_PKK check (TrangThai in ( N'Chờ duyệt', N'Đã duyệt' , N'Đã Hủy') )
);
GO
CREATE TABLE PhieuKiemKeChiTiet (
    MaPKK INT NOT NULL,
    MaVatTu INT NOT NULL,
    MaViTri VARCHAR(10) NOT NULL,
    SoLuongHeThong INT NOT NULL,
    SoLuongThucTe INT NOT NULL,
    ChenhLech AS (SoLuongThucTe - SoLuongHeThong) PERSISTED,
    CONSTRAINT PK_PKKCT PRIMARY KEY (MaPKK, MaVatTu, MaViTri),
    CONSTRAINT FK_PKKCT_PKK FOREIGN KEY (MaPKK) REFERENCES PhieuKiemKe(MaPKK),
    CONSTRAINT FK_PKKCT_VatTu FOREIGN KEY (MaVatTu) REFERENCES VatTu(MaVatTu),
    CONSTRAINT FK_PKKCT_ViTri FOREIGN KEY (MaViTri) REFERENCES ViTri(MaViT)
);
GO
Create table PhieuDieuChinh (
    MaPDCHI INT IDENTITY (1,1) PRIMARY KEY , 
    MaKho int not null , 
    MaNV int not null , 
    MaKK int , 
    NgayDieuChinh Date not null , 
    LyDo nvarchar(255) , 
    TrangThai Nvarchar(20) Default N'Chờ duyệt', 
	Constraint FK_MK_PDCHI foreign key (MaKho) references Kho(MaKho) ,
	Constraint FK_MNV_PDCHI foreign key (MaNV) references NhanVien(MaNV) ,
	Constraint FK_MaKK_PDCHI foreign key (MaKK) References PhieuKiemKe(MaPKK) , 
	Constraint CHECK_TT_PDCHI check (TrangThai in (N'Chờ duyệt', N'Đã duyệt' , N'Đã Hủy'))
) ; 
GO
Create table PhieuDieuChinhChiTiet (
    MaPDCHI  int not null ,
    MaVatTu int not null ,
    MaViTri varchar(10) not null ,
    SoLuongHeThong int not null ,   
    SoLuongDieuChinh int not null , 
    ChenhLech as (SoLuongDieuChinh - SoLuongHeThong) persisted ,
    LyDo nvarchar(255) ,
    Constraint PK_PDCCT primary key (MaPDCHI, MaVatTu, MaViTri) ,
    Constraint FK_PDCCT_PDC foreign key (MaPDCHI) references PhieuDieuChinh(MaPDCHI) ,
    Constraint FK_PDCCT_VatTu foreign key (MaVatTu) references VatTu(MaVatTu) ,
    Constraint FK_PDCCT_ViTri foreign key (MaViTri) references ViTri(MaViT)
) ;
GO
----------------------------------
---GHI NHẬN LỊCH SỬ -------------
-----------------------------------
Create table LichSuDuyet (
    ID int identity (1,1) primary key ,
    LoaiPhieu nvarchar(20) ,
    MaPhieu varchar(100) not null ,
    NguoiGui int not null ,
    NguoiDuyet int ,
    BuocDuyet int ,
    TrangThai nvarchar(20) ,
    NgayGui datetime default getdate() ,
    NgayDuyet datetime ,
    LyDoTuChoi nvarchar(255) ,
    Constraint FK_LSD_NguoiGui foreign key (NguoiGui) references NhanVien(MaNV) ,
    Constraint FK_LSD_NguoiDuyet foreign key (NguoiDuyet) references NhanVien(MaNV)
) ;
GO 
----------------------------------
---TRIGGER -----------------------
-----------------------------------
Create Trigger CAPNHAT_TONKHO_NHAPKHO 
ON PhieuNhapKhoChiTiet
after insert , update 
as 
begin 
  Declare @MaKho int 
  select TOP 1 @MaKho = P.MaKho  from PhieuNhapKho as P , Inserted as I 
  WHERE i.MaPNK = P.MaPNK
  Merge into TonKhoVatTu as Target 
  USING  ( 
     select i.MaVatTu, SUM(i.Soluong) as SoLuong 
     from Inserted as i 
     GROUP BY i.MaVatTu ) as Source 
  on Target.MaVatTu = Source.MaVatTu and Target.MaKho = @MaKho 
  when Matched then 
   update set Target.Soluong = Target.Soluong + Source.SoLuong 
  when not matched then 
   insert  (MaVatTu, MaKho, Soluong ) 
   values ( Source.MaVatTu, @MaKho, Source.Soluong ) ; 
  Merge into TonKhoChiTiet as Target 
  Using ( 
     Select MaPNK, MaVatTu, MaViT,
 Soluong 
	 from Inserted 
	  ) as Source 
  on Target.MaVatTu = Source.MaVatTu and Target.MaViTri = Source.MaViT and Target.MaKho = @MaKho 
  when matched then 
    update set Target.Soluong = Target.Soluong + Source.Soluong 
  when not matched then 
    Insert ( MaVatTu, MaViTri , MaKho, SoLuong ) 
	values ( Source.MaVatTu, Source.MaViT , @Makho, Source.Soluong ) ; 
end 
Go 
Create Trigger CAPNHAT_TONKHO_XUATKHO 
 on PhieuXuatKhoChiTiet 
 after Insert, Update 
 as  
 begin 
  Declare @Makho int  
  select TOP 1 @Makho = P.MaKho  
  from PhieuXuatKho as P , Inserted as i 
  where P.MaPXK = i.MaPXK 
  if exists (
  select 1 from inserted as i , TonkhoChiTiet  as t 
  WHERE i.MaVatTu = t.MaVatTu  and T.MaKho = @MaKho and t.MaViTri = i.MaViT  and isnull(t.SoLuong,0 
  ) < i.SoLuong ) 
   begin 
     RAISERROR (N'Không đủ hàng để xuất !',16,1 ) ; 
	 Rollback tran 
	 Return ; 
   end ; 
    Update t 
	set t.Soluong = t.Soluong - i.Soluong 
    From TonKhoVatTu as t , (Select MaVatTu, Sum(SoLuong) as Soluong from inserted  group by MaVatTu) as i 
	where t.MaVatTu = i.MaVatTu and t.MaKho = @MaKho 
    Update t 
	set t.Soluong = t.Soluong - i.Soluong 
    From TonKhoChiTiet as t , inserted as i 
	where t.MaVatTu = i.MaVatTu and t.MaKho = @MaKho and t.MaViTri = i.MaViT
end 
GO 
CREATE Trigger TONGGIAPNK  
ON PhieuNhapKhoChiTiet
FOR INSERT, Update 
as 
begin 
 Update P1 
 SET  P1.TongGia = ISNULL(P1.TongGia, 0) + P2.TongGia 
 From ( Select MaPNK,Sum(GiaTri) as TongGia FROM INSERTED GROUP BY MaPNK  ) as P2, PhieuNhapKho as P1 
 where P1.MaPNK = P2.MaPNK 
end 
GO 
CREATE Trigger TONGGIAPXK  
ON PhieuXuatKhoChiTiet 
FOR INSERT, Update 
as 
begin 
 Update P1 
 SET  P1.TongGia = ISNULL(P1.TongGia, 0) + P2.TongGia 
 From ( Select MaPXK,Sum(GiaTri) as TongGia FROM INSERTED GROUP BY MaPXK  ) as P2, PhieuXuatKho as P1 
 where P1.MaPXK = P2.MaPXK 
end 
Go 
----------------------------------
---Procedure -----------------------
-----------------------------------
CREATE PROCEDURE PR_GoiYPhanBoHangHoa
    @MaKho INT,
    @SoLuongCanNhap INT
AS
BEGIN
  WITH SucChua AS (
        SELECT
		    V.MaViT, 
            (V.DungTich - ISNULL(SUM(t.SoLuong), 0)) AS ChoTrong
        FROM Vitri V
        INNER JOIN KhuVuc K ON K.MaKV = V.MaKV
        LEFT JOIN TonKhoChiTiet t ON V.MaViT = t.MaViTri
        WHERE K.MaKho = @MaKho
        GROUP BY V.MaViT, V.DungTich
        HAVING  (V.DungTich - ISNULL(SUM(t.SoLuong), 0)) > 0),
    LuyKe AS (
        SELECT 
            MaViT, 
            ChoTrong,
            SUM(ChoTrong) OVER (ORDER BY ChoTrong) AS TongLuyKe
        FROM SucChua )
    SELECT  MaViT,
    ChoTrong AS SucChuaHienTai,
    CASE 
      WHEN TongLuyKe <= @SoLuongCanNhap THEN ChoTrong
      ELSE @SoLuongCanNhap - (TongLuyKe - ChoTrong)
    END AS SoLuongDeXuat
    FROM LuyKe
    WHERE  (TongLuyKe - ChoTrong) < @SoLuongCanNhap;
END;
GO
CREATE PROCEDURE SP_GoiYLayHangHoa
    @MaKho INT,
    @MaVatTu INT, 
    @SoLuongCanXuat INT 
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH TonKho AS (
        SELECT 
            MaViTri, 
            SoLuong 
        FROM TonKhoChiTiet 
        WHERE MaKho = @MaKho 
          AND MaVatTu = @MaVatTu
          AND SoLuong > 0
    ),
    LuyKe AS (
        SELECT 
            MaViTri,  
            SoLuong,
            SUM(SoLuong) OVER (ORDER BY SoLuong) AS TongLuyKe
        FROM TonKho 
    )
    SELECT 
        MaViTri,
        SoLuong AS SoLuongHienTai,
        CASE 
            WHEN TongLuyKe <= @SoLuongCanXuat 
                THEN SoLuong
            ELSE @SoLuongCanXuat - (TongLuyKe - SoLuong)
        END AS SoLuongDeXuat
    FROM LuyKe
    WHERE (TongLuyKe - SoLuong) < @SoLuongCanXuat;
END;
GO


