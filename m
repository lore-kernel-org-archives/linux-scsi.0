From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [PATCH] ipr: Driver version 2.5.2
Date: Wed, 27 Apr 2011 14:43:40 -0300
Message-ID: <1303926220.10749.6.camel@dream>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:60721 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab1D0Rny (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2011 13:43:54 -0400
Received: from /spool/local
	by e24smtp04.br.ibm.com with XMail ESMTP
	for <linux-scsi@vger.kernel.org> from <klebers@linux.vnet.ibm.com>;
	Wed, 27 Apr 2011 14:43:51 -0300
Received: from d24av03.br.ibm.com (d24av03.br.ibm.com [9.8.31.95])
	by mailhub1.br.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3RHinXW1019932
	for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2011 14:44:53 -0300
Received: from d24av03.br.ibm.com (loopback [127.0.0.1])
	by d24av03.br.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3RHhk8x000765
	for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2011 14:43:46 -0300
Received: from [9.12.225.165] ([9.12.225.165])
	by d24av03.br.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p3RHhi7S000692
	for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2011 14:43:45 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Bump the driver version.

Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index 4e9701e..f93f863 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -38,8 +38,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.5.1"
-#define IPR_DRIVER_DATE "(August 10, 2010)"
+#define IPR_DRIVER_VERSION "2.5.2"
+#define IPR_DRIVER_DATE "(April 27, 2011)"

 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
-- 
1.7.1



