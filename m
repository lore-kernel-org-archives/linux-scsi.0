From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: [PATCH] ibmvscsi: includecheck fix
Date: Fri, 04 Sep 2009 23:26:18 +0530
Message-ID: <1252086978.6385.4.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:35593 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173AbZIDR7q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Sep 2009 13:59:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Jennings <rcj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, Paul Mackerras <paulus@samba.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Benjamin


fix the following 'make includecheck' warning:

  drivers/scsi/ibmvscsi/ibmvscsi.c: asm/firmware.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 9928704..d9b0e9d 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -73,7 +73,6 @@
 #include <linux/of.h>
 #include <asm/firmware.h>
 #include <asm/vio.h>
-#include <asm/firmware.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
-- 
1.6.0.6


