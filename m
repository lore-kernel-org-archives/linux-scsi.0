From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 01/22] qla2xxx: Fix typo in qla_init.c
Date: Tue, 15 May 2012 14:34:08 -0400
Message-ID: <1337106869-14191-2-git-send-email-chad.dupuis@qlogic.com>
References: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:46989 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S966427Ab2EOS50 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 May 2012 14:57:26 -0400
In-Reply-To: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Raul Porcel <armin76@gentoo.org>

Replace "Inconisistent" with "Inconsistent" in drivers/scsi/qla2xxx/qla_init.c

Signed-off-by: Raul Porcel <armin76@gentoo.org>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b946564..7428143 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2185,7 +2185,7 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 	    nv->id[2] != 'P' || nv->id[3] != ' ' || nv->nvram_version < 1) {
 		/* Reset NVRAM data. */
 		ql_log(ql_log_warn, vha, 0x0064,
-		    "Inconisistent NVRAM "
+		    "Inconsistent NVRAM "
 		    "detected: checksum=0x%x id=%c version=0x%x.\n",
 		    chksum, nv->id[0], nv->nvram_version);
 		ql_log(ql_log_warn, vha, 0x0065,
@@ -4279,7 +4279,7 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 	    nv->nvram_version < __constant_cpu_to_le16(ICB_VERSION)) {
 		/* Reset NVRAM data. */
 		ql_log(ql_log_warn, vha, 0x006b,
-		    "Inconisistent NVRAM detected: checksum=0x%x id=%c "
+		    "Inconsistent NVRAM detected: checksum=0x%x id=%c "
 		    "version=0x%x.\n", chksum, nv->id[0], nv->nvram_version);
 		ql_log(ql_log_warn, vha, 0x006c,
 		    "Falling back to functioning (yet invalid -- WWPN) "
@@ -5029,7 +5029,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	    nv->nvram_version < __constant_cpu_to_le16(ICB_VERSION)) {
 		/* Reset NVRAM data. */
 		ql_log(ql_log_info, vha, 0x0073,
-		    "Inconisistent NVRAM detected: checksum=0x%x id=%c "
+		    "Inconsistent NVRAM detected: checksum=0x%x id=%c "
 		    "version=0x%x.\n", chksum, nv->id[0],
 		    le16_to_cpu(nv->nvram_version));
 		ql_log(ql_log_info, vha, 0x0074,
-- 
1.7.7

