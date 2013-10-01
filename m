From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH 4/4] esas2r: Cleanup snprinf formatting of firmware version
Date: Tue, 1 Oct 2013 14:26:04 -0400
Message-ID: <1380651964-8124-4-git-send-email-bgrove@attotech.com>
References: <1380651964-8124-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:51974 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752572Ab3JASf0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Oct 2013 14:35:26 -0400
In-Reply-To: <1380651964-8124-1-git-send-email-bgrove@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@parallels.com
Cc: jseba@attotech.com, Bradley Grove <bgrove@attotech.com>

Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 drivers/scsi/esas2r/esas2r_vda.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_vda.c b/drivers/scsi/esas2r/esas2r_vda.c
index 27e9721..30028e5 100644
--- a/drivers/scsi/esas2r/esas2r_vda.c
+++ b/drivers/scsi/esas2r/esas2r_vda.c
@@ -310,9 +310,9 @@ static void esas2r_complete_vda_ioctl(struct esas2r_adapter *a,
 				le32_to_cpu(rsp->vda_version);
 			cfg->data.init.fw_build = rsp->fw_build;
 
-			snprintf(buf, sizeof(buf), "%1d.%02d",
-				(int)LOBYTE(le16_to_cpu(rsp->fw_release)),
-				(int)HIBYTE(le16_to_cpu(rsp->fw_release)));
+			snprintf(buf, sizeof(buf), "%1.1u.%2.2u",
+				 (int)LOBYTE(le16_to_cpu(rsp->fw_release)),
+				 (int)HIBYTE(le16_to_cpu(rsp->fw_release)));
 
 			memcpy(&cfg->data.init.fw_release, buf,
 			       sizeof(cfg->data.init.fw_release));
-- 
1.8.3.1

