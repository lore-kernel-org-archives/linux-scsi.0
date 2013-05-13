From: Vijaya Mohan Guvva <vmohan@brocade.com>
Subject: [PATCH V1 17/17] bfa: Update the driver version to 3.2.21.1
Date: Mon, 13 May 2013 02:33:35 -0700
Message-ID: <1368437615-9867-18-git-send-email-vmohan@brocade.com>
References: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:50343 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754095Ab3EMJwF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 May 2013 05:52:05 -0400
In-Reply-To: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, adapter_linux_open_src_team@Brocade.COM, Vijaya Mohan Guvva <vmohan@Brocade.COM>

Update bfa driver version to 3.2.21.1
Update bfa to use firmware image versions 3.2.1.0

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfad.c     | 6 +++---
 drivers/scsi/bfa/bfad_drv.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index bf5c5d3..9611195 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -63,9 +63,9 @@ int		max_rport_logins = BFA_FCS_MAX_RPORT_LOGINS;
 u32	bfi_image_cb_size, bfi_image_ct_size, bfi_image_ct2_size;
 u32	*bfi_image_cb, *bfi_image_ct, *bfi_image_ct2;
 
-#define BFAD_FW_FILE_CB		"cbfw-3.1.0.0.bin"
-#define BFAD_FW_FILE_CT		"ctfw-3.1.0.0.bin"
-#define BFAD_FW_FILE_CT2	"ct2fw-3.1.0.0.bin"
+#define BFAD_FW_FILE_CB		"cbfw-3.2.1.0.bin"
+#define BFAD_FW_FILE_CT		"ctfw-3.2.1.0.bin"
+#define BFAD_FW_FILE_CT2	"ct2fw-3.2.1.0.bin"
 
 static u32 *bfad_load_fwimg(struct pci_dev *pdev);
 static void bfad_free_fwimg(void);
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 0c64a04..78d3401 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -57,7 +57,7 @@
 #ifdef BFA_DRIVER_VERSION
 #define BFAD_DRIVER_VERSION    BFA_DRIVER_VERSION
 #else
-#define BFAD_DRIVER_VERSION    "3.1.2.1"
+#define BFAD_DRIVER_VERSION    "3.2.21.1"
 #endif
 
 #define BFAD_PROTO_NAME FCPI_NAME
-- 
1.7.12

