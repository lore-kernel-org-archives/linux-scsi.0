From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 8/8] lpfc 8.3.4: Update driver version to 8.3.4
Date: Sun, 19 Jul 2009 10:01:44 -0400
Message-ID: <1248012104.15009.36.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:34714 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbZGSOBq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2009 10:01:46 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n6JE1khl021617
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jul 2009 07:01:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Update driver version to 8.3.4

Signed-off-by: James Smart <James.Smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.3"
+#define LPFC_DRIVER_VERSION "8.3.4"
 
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"


