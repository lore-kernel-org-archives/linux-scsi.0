From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/5] lpfc 10.2.8001.0: Update lpfc version to driver version
 10.2.8001.0
Date: Mon, 12 May 2014 11:53:43 -0400
Message-ID: <1399910023.25346.12.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:51529 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbaELPxp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 May 2014 11:53:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update lpfc version to driver version 10.2.8001.0


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2014-05-12 09:45:34.440083588 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2014-05-12 09:49:41.499096032 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "10.2.8000.0."
+#define LPFC_DRIVER_VERSION "10.2.8001.0."
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
@@ -30,4 +30,4 @@
 
 #define LPFC_MODULE_DESC "Emulex LightPulse Fibre Channel SCSI driver " \
 		LPFC_DRIVER_VERSION
-#define LPFC_COPYRIGHT "Copyright(c) 2004-2013 Emulex.  All rights reserved."
+#define LPFC_COPYRIGHT "Copyright(c) 2004-2014 Emulex.  All rights reserved."



