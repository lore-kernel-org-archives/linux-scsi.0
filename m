From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 6/6] lpfc 8.3.6 : Update lpfc driver version to 8.3.6
Date: Wed, 18 Nov 2009 15:41:46 -0500
Message-ID: <1258576926.29086.20.camel@wookie>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51027 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527AbZKRUmC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2009 15:42:02 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id nAIKg8cf012813
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2009 12:42:08 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update lpfc driver version to 8.3.6
 
 Signed-off-by: James Smart <james.smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 49727c2..c7f3aed 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.5"
+#define LPFC_DRIVER_VERSION "8.3.6"
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"
 #define LPFC_FP_DRIVER_HANDLER_NAME	"lpfc:fp"
-- 
1.6.0.6



