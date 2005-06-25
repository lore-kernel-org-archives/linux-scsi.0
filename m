From: James.Smart@Emulex.Com
Subject: [PATCH 12 of 12] Update Emulex lpfc driver to rev 8.0.29
Date: Sat, 25 Jun 2005 10:34:42 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F4151@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:48830 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261265AbVFYOeo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jun 2005 10:34:44 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j5PEYh9P008218
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jun 2005 07:34:43 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Change version to 8.0.29.

Signed-off-by: James Smart <James.Smart@emulex.com>

---

 scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_version.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/lpfc/lpfc_version.h~version drivers/scsi/lpfc/lpfc_version.h
--- scsi-misc-2.6-20050620/drivers/scsi/lpfc/lpfc_version.h~version	2005-06-25 09:43:02.000000000 -0400
+++ scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_version.h	2005-06-25 09:43:02.000000000 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.0.28"
+#define LPFC_DRIVER_VERSION "8.0.29"
 
 #define LPFC_DRIVER_NAME "lpfc"
 
_
