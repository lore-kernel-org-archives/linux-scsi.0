From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 5/5] lpfc 8.3.3 : Update driver version to 8.3.3
Date: Wed, 10 Jun 2009 17:23:24 -0400
Message-ID: <1244669004.9571.23.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:37973 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254AbZFJVX0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2009 17:23:26 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n5ALNSRA001429
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2009 14:23:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Update driver version to 8.3.3

Signed-off-by: James Smart <James.Smart@emulex.com>
---

 drivers/scsi/lpfc/lpfc_version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.2"
+#define LPFC_DRIVER_VERSION "8.3.3"
 
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"


