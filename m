From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [1/3] add MODULE_VERSION to drivers/scsi
Date: Wed, 21 Jul 2004 17:02:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040721220204.GB16608@lists.us.dell.com>
References: <20040721220111.GA16608@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linux.us.dell.com ([143.166.224.162]:45657 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S266756AbUGUWDB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2004 18:03:01 -0400
Content-Disposition: inline
In-Reply-To: <20040721220111.GA16608@lists.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jgarzik@pobox.com

You can import this changeset into BK by piping this whole message to
'| bk receive [path to repository]' or apply the patch as usual.

===================================================================


ChangeSet@1.1842.1.1, 2004-07-19 17:57:27-04:00, Matt_Domsch@dell.com
  Set MODULE_VERSION for drivers/scsi/ SATA, libata, and ata_piix.


 ata_piix.c     |    1 +
 libata-core.c  |    1 +
 sata_nv.c      |    1 +
 sata_promise.c |    1 +
 sata_sil.c     |    1 +
 sata_sis.c     |    1 +
 sata_svw.c     |    1 +
 sata_sx4.c     |    1 +
 sata_via.c     |    1 +
 sata_vsc.c     |    1 +
 10 files changed, 10 insertions


diff -Nru a/drivers/scsi/ata_piix.c b/drivers/scsi/ata_piix.c
--- a/drivers/scsi/ata_piix.c	2004-07-21 16:57:05 -05:00
+++ b/drivers/scsi/ata_piix.c	2004-07-21 16:57:05 -05:00
@@ -226,6 +226,7 @@
 MODULE_DESCRIPTION("SCSI low-level driver for Intel PIIX/ICH ATA controllers");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, piix_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
 
 /**
  *	piix_pata_cbl_detect - Probe host controller cable detect info
diff -Nru a/drivers/scsi/libata-core.c b/drivers/scsi/libata-core.c
--- a/drivers/scsi/libata-core.c	2004-07-21 16:57:05 -05:00
+++ b/drivers/scsi/libata-core.c	2004-07-21 16:57:05 -05:00
@@ -62,6 +62,7 @@
 MODULE_AUTHOR("Jeff Garzik");
 MODULE_DESCRIPTION("Library module for ATA devices");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
 
 /**
  *	ata_tf_load_pio - send taskfile registers to host controller
diff -Nru a/drivers/scsi/sata_nv.c b/drivers/scsi/sata_nv.c
--- a/drivers/scsi/sata_nv.c	2004-07-21 16:57:05 -05:00
+++ b/drivers/scsi/sata_nv.c	2004-07-21 16:57:05 -05:00
@@ -154,6 +154,7 @@
 MODULE_DESCRIPTION("low-level driver for NVIDIA nForce SATA controller");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, nv_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
 
 irqreturn_t nv_interrupt (int irq, void *dev_instance, struct pt_regs *regs)
 {
diff -Nru a/drivers/scsi/sata_promise.c b/drivers/scsi/sata_promise.c
--- a/drivers/scsi/sata_promise.c	2004-07-21 16:57:05 -05:00
+++ b/drivers/scsi/sata_promise.c	2004-07-21 16:57:05 -05:00
@@ -670,6 +670,7 @@
 MODULE_DESCRIPTION("Promise SATA TX2/TX4 low-level driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, pdc_sata_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
 
 module_init(pdc_sata_init);
 module_exit(pdc_sata_exit);
diff -Nru a/drivers/scsi/sata_sil.c b/drivers/scsi/sata_sil.c
--- a/drivers/scsi/sata_sil.c	2004-07-21 16:57:05 -05:00
+++ b/drivers/scsi/sata_sil.c	2004-07-21 16:57:05 -05:00
@@ -185,6 +185,7 @@
 MODULE_DESCRIPTION("low-level driver for Silicon Image SATA controller");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, sil_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
 
 static void sil_post_set_mode (struct ata_port *ap)
 {
diff -Nru a/drivers/scsi/sata_sis.c b/drivers/scsi/sata_sis.c
--- a/drivers/scsi/sata_sis.c	2004-07-21 16:57:05 -05:00
+++ b/drivers/scsi/sata_sis.c	2004-07-21 16:57:05 -05:00
@@ -116,6 +116,7 @@
 MODULE_DESCRIPTION("low-level driver for Silicon Integratad Systems SATA controller");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, sis_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
 
 static unsigned int get_scr_cfg_addr(unsigned int port_no, unsigned int sc_reg)
 {
diff -Nru a/drivers/scsi/sata_svw.c b/drivers/scsi/sata_svw.c
--- a/drivers/scsi/sata_svw.c	2004-07-21 16:57:05 -05:00
+++ b/drivers/scsi/sata_svw.c	2004-07-21 16:57:05 -05:00
@@ -398,6 +398,7 @@
 MODULE_DESCRIPTION("low-level driver for K2 SATA controller");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, k2_sata_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
 
 module_init(k2_sata_init);
 module_exit(k2_sata_exit);
diff -Nru a/drivers/scsi/sata_sx4.c b/drivers/scsi/sata_sx4.c
--- a/drivers/scsi/sata_sx4.c	2004-07-21 16:57:05 -05:00
+++ b/drivers/scsi/sata_sx4.c	2004-07-21 16:57:05 -05:00
@@ -1457,6 +1457,7 @@
 MODULE_DESCRIPTION("Promise SATA low-level driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, pdc_sata_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
 
 module_init(pdc_sata_init);
 module_exit(pdc_sata_exit);
diff -Nru a/drivers/scsi/sata_via.c b/drivers/scsi/sata_via.c
--- a/drivers/scsi/sata_via.c	2004-07-21 16:57:05 -05:00
+++ b/drivers/scsi/sata_via.c	2004-07-21 16:57:05 -05:00
@@ -127,6 +127,7 @@
 MODULE_DESCRIPTION("SCSI low-level driver for VIA SATA controllers");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, svia_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
 
 static u32 svia_scr_read (struct ata_port *ap, unsigned int sc_reg)
 {
diff -Nru a/drivers/scsi/sata_vsc.c b/drivers/scsi/sata_vsc.c
--- a/drivers/scsi/sata_vsc.c	2004-07-21 16:57:05 -05:00
+++ b/drivers/scsi/sata_vsc.c	2004-07-21 16:57:05 -05:00
@@ -382,6 +382,7 @@
 MODULE_DESCRIPTION("low-level driver for Vitesse VSC7174 SATA controller");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, vsc_sata_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
 
 module_init(vsc_sata_init);
 module_exit(vsc_sata_exit);

===================================================================


This BitKeeper patch contains the following changesets:
1.1842.1.1
## Wrapped with gzip_uu ##


M'XL( +'F_D   \V9;6_:2!" /\>_PE*_W.F*V=GWI<J)7!/UJFLO4=+T2U5%
MR]H$7P!'7H>FE7_\K4T TY"P6+D3O BTLH>9>79>=G@57MHD[QU\U$5Q=9Q-
MK!D%K\(_,UOT#N)D/(Y,-G$+YUGF%KJC;))T)W%]67=PTYUD\2S);7><3N_N
M.SCBG8>5-)O:P-UWI@LS"JN5W@%$9+E2?+]->@?G)^\N/QR=!\'A8?AVI*?7
MR452A(>'09'E,SV.;5\7HW$VC8I<3^TD*72E3KF\M,0(8?=D( ABO 2.J"@-
MQ ":0A(C3"6GP22]&6>V;W\D>1*GT>CNRT+^UW59% D0""BEJ@0L$ J.0XA 
M4ARYCQ#1+A)=4"&('A,]+#J(]A *&[[K+WP6_@8H[*#@C_!E;7D;F+!RTL?3
MX\L/)U>?3\XOWI_^'0ZS/(SSM(9AC4V[X<71IZ/7X3@=Z$*_#O4T#MV7J]LT
MO8^"OT(@1/#@;.7UH+/C(PB01L'OX3_7.O^1WO2=:T>ZJ&U:4\16/VMGWR)3
M64@ 8< $ W$6TLI"1;0F3%).-6)J&&_TYG,B*V@* Q- 2BP)$&^ETO$&I0@E
MN$PXT\.AY@#) &#@K]1"9%,I9QSU\=2<5<=D>;)!+R0$+1,#*I9&*TT30(1Z
MZ/5(:E,U<-L-5ZJYR)A\[]OKM!+PY4'3KQLLG%FS$$.0 A<O%)<(@4(EYER 
M01 ;B1D@Y>NTALB&9IQ1\"=IETIA<+<2YS',"<>EXH"'0AH@2(N!V8&DW;"]
M! 'AJ]0LU8\Q8H8H+ZED;EL9%X*<,A@(;T\M1#:5HL!PTU.WV2"[?T+ =+:X
MG[M$1UP TM))H:@<<AD+.<1#C(D6ROBJM)+8V/!8,NS-[IYNV.U8*%9R/$RT
M451KA8S!VIO=0N2Z4I0Q7Z5N\VR2VDUA6"N6""(21F(Q$#&19G,%V"9V;;>#
MY#XI8IG"-^0'H&XO*#;0P@R',# * ?90;%WDFE*$$U+7YB=BMJK4_TGF"'SV
M<C-MN#=VFQE<3:$ \ZK-?Z[70)ZOU_]?N:X*<)W?3L-._JU^N8)Z]I2?6]3F
M]T32$(+UG_WE^/SSXONO;YX@6P5T#?9%T\F.XE9 &1(8UT#%7O.<Y[RM/"L3
MV^ $QG?&N8KL)L^72BW;B#[**ZL8!89(C12SO68Z3X#/,5T9V08JQG)GJ&OM
MG _7%EUE<)'DUVD6O4O&NLCZVA9Y%MF[R"9/Y/>-/2;%"("P$DDBYQ$LT7[C
MKIOAYW"OV=F&.&^9E)>-@P_Q-AV,5W[^N7VI\SXFLD3*>;Q&3.5^(Z[[K*U9
M>FEH*\8"MX-<'QZ] >]P>O6"VSRZKJHO=])KL.31^&.OP,[/V%O!UD:VJK]2
MM(5J=X+J?9#UA&H?0W4MMA3S'GF_H<Z/VQY0;4NHL'O]7<V>_*'Z#[_\H#8F
M7RNH'.1#4[7G4.L1W7:HE9%MH%)G9SNHU=3 'ZK_V,(/:F-FX=[4\:P./P2S
M&BK;;ZCSX<IVJ)61K2*5,M6.:CTR\Z:ZP\S.;T;1&-@M0Y4HHN8S"KS?#?%\
FLKA]1E$9V8HJW@YU\8>1&27FQMY-#H4R.%; @W\!N[(4(KH:    
