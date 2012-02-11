From: =?UTF-8?q?Ra=C3=BAl=20Porcel?= <armin76@gentoo.org>
Subject: [PATCH] [trivial] qla2xxx: Fix typo in qla_init.c
Date: Sat, 11 Feb 2012 19:00:42 +0000
Message-ID: <1328986842-24384-1-git-send-email-armin76@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:55310 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab2BKTCQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Feb 2012 14:02:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, linux-driver@qlogic.com, linux-scsi@vger.kernel.org
Cc: =?UTF-8?q?Ra=C3=BAl=20Porcel?= <armin76@gentoo.org>

Replace "Inconisistent" with "Inconsistent" in
drivers/scsi/qla2xxx/qla_init.c

Signed-off-by: Ra=C3=BAl Porcel <armin76@gentoo.org>
---
 drivers/scsi/qla2xxx/qla_init.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla=
_init.c
index 1fa067e..72f7aa3 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2230,7 +2230,7 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 	    nv->id[2] !=3D 'P' || nv->id[3] !=3D ' ' || nv->nvram_version < 1=
) {
 		/* Reset NVRAM data. */
 		ql_log(ql_log_warn, vha, 0x0064,
-		    "Inconisistent NVRAM "
+		    "Inconsistent NVRAM "
 		    "detected: checksum=3D0x%x id=3D%c version=3D0x%x.\n",
 		    chksum, nv->id[0], nv->nvram_version);
 		ql_log(ql_log_warn, vha, 0x0065,
@@ -4425,7 +4425,7 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 	    nv->nvram_version < __constant_cpu_to_le16(ICB_VERSION)) {
 		/* Reset NVRAM data. */
 		ql_log(ql_log_warn, vha, 0x006b,
-		    "Inconisistent NVRAM detected: checksum=3D0x%x id=3D%c "
+		    "Inconsistent NVRAM detected: checksum=3D0x%x id=3D%c "
 		    "version=3D0x%x.\n", chksum, nv->id[0], nv->nvram_version);
 		ql_log(ql_log_warn, vha, 0x006c,
 		    "Falling back to functioning (yet invalid -- WWPN) "
@@ -5169,7 +5169,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	    nv->nvram_version < __constant_cpu_to_le16(ICB_VERSION)) {
 		/* Reset NVRAM data. */
 		ql_log(ql_log_info, vha, 0x0073,
-		    "Inconisistent NVRAM detected: checksum=3D0x%x id=3D%c "
+		    "Inconsistent NVRAM detected: checksum=3D0x%x id=3D%c "
 		    "version=3D0x%x.\n", chksum, nv->id[0],
 		    le16_to_cpu(nv->nvram_version));
 		ql_log(ql_log_info, vha, 0x0074,
--=20
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
