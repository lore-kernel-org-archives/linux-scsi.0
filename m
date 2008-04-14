From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] sun3_scsi_vme.c: add MODULE_LICENSE
Date: Mon, 14 Apr 2008 17:17:26 +0300
Message-ID: <20080414141726.GJ6695@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760362AbYDNOVJ@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch adds the missing MODULE_LICENSE("GPL").

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
899d0052f8e3fbe4aa465ef98c10408307ee46a5 diff --git a/drivers/scsi/sun3_scsi_vme.c b/drivers/scsi/sun3_scsi_vme.c
index 02d9727..aaa4fd0 100644
--- a/drivers/scsi/sun3_scsi_vme.c
+++ b/drivers/scsi/sun3_scsi_vme.c
@@ -582,3 +582,4 @@ static struct scsi_host_template driver_template = {
 
 #include "scsi_module.c"
 
+MODULE_LICENSE("GPL");
