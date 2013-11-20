From: <vmohan@brocade.com>
Subject: [PATCH 8/8] bfa: Driver version upgrade to 3.2.23.0
Date: Tue, 19 Nov 2013 23:05:46 -0800
Message-ID: <1384931146-3702-9-git-send-email-vmohan@brocade.com>
References: <1384931146-3702-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:36175 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080Ab3KTHmH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Nov 2013 02:42:07 -0500
In-Reply-To: <1384931146-3702-1-git-send-email-vmohan@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: agurumur@brocade.com, james.bottomley@hansenpartnership.com

From: Vijaya Mohan Guvva <vmohan@brocade.com>

Patch includes changes to upgrade bfa driver version to 3.2.23.0 and use
firmware version 3.2.3.0

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfad.c     | 6 +++---
 drivers/scsi/bfa/bfad_drv.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index bd17757..e85926c 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -63,9 +63,9 @@ int		max_rport_logins = BFA_FCS_MAX_RPORT_LOGINS;
 u32	bfi_image_cb_size, bfi_image_ct_size, bfi_image_ct2_size;
 u32	*bfi_image_cb, *bfi_image_ct, *bfi_image_ct2;
 
-#define BFAD_FW_FILE_CB		"cbfw-3.2.1.1.bin"
-#define BFAD_FW_FILE_CT		"ctfw-3.2.1.1.bin"
-#define BFAD_FW_FILE_CT2	"ct2fw-3.2.1.1.bin"
+#define BFAD_FW_FILE_CB		"cbfw-3.2.3.0.bin"
+#define BFAD_FW_FILE_CT		"ctfw-3.2.3.0.bin"
+#define BFAD_FW_FILE_CT2	"ct2fw-3.2.3.0.bin"
 
 static u32 *bfad_load_fwimg(struct pci_dev *pdev);
 static void bfad_free_fwimg(void);
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index cf56d3d..8b97877 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -57,7 +57,7 @@
 #ifdef BFA_DRIVER_VERSION
 #define BFAD_DRIVER_VERSION    BFA_DRIVER_VERSION
 #else
-#define BFAD_DRIVER_VERSION    "3.2.21.1"
+#define BFAD_DRIVER_VERSION    "3.2.23.0"
 #endif
 
 #define BFAD_PROTO_NAME FCPI_NAME
-- 
1.8.2.1

