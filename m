From: David Milburn <dmilburn@redhat.com>
Subject: [PATCH] megaraid: update version reported by MEGAIOC_QDRVRVER
Date: Thu, 19 Apr 2007 12:10:24 -0500
Message-ID: <20070419171024.GA6885@dhcp-210.hsv.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161504AbXDSRL2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Apr 2007 13:11:28 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, dmilburn@redhat.com

Update the driver version reported by MEGAIOC_QDRVRVER to
match LSI_COMMON_MOD_VERSION.

Signed-off-by: David Milburn <dmilburn@redhat.com>
---

 drivers/scsi/megaraid/megaraid_mm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index f33a678..e075a52 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -60,7 +60,7 @@ EXPORT_SYMBOL(mraid_mm_unregister_adp);
 EXPORT_SYMBOL(mraid_mm_adapter_app_handle);
 
 static int majorno;
-static uint32_t drvr_ver	= 0x02200206;
+static uint32_t drvr_ver	= 0x02200207;
 
 static int adapters_count_g;
 static struct list_head adapters_list_g;
