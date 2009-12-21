From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/6] lpfc 8.3.7: Update Driver version to 8.3.7
Date: Mon, 21 Dec 2009 17:03:47 -0500
Message-ID: <1261433047.12238.18.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38078 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757302AbZLUWIM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2009 17:08:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update Driver version to 8.3.7

Signed-off-by: James Smart <james.smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index c7f3aed..792f722 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.6"
+#define LPFC_DRIVER_VERSION "8.3.7"
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"
 #define LPFC_FP_DRIVER_HANDLER_NAME	"lpfc:fp"
-- 
1.6.5.2



