From: brking@us.ibm.com
Subject: [PATCH 03/16] ipr: Add maintainers email address to comment block
Date: Wed, 04 Aug 2004 17:31:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408042231.i74MVku7201706@westrelay04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:45535 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S267464AbUHDWbs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Aug 2004 18:31:48 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com



The following patch adds my email address to the block comment
at the start of each file of the ipr driver to make it easier to find.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c |    2 +-
 linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_maintainer_email drivers/scsi/ipr.c
--- linux-2.6.8-rc3/drivers/scsi/ipr.c~ipr_maintainer_email	2004-08-04 17:17:25.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c	2004-08-04 17:17:25.000000000 -0500
@@ -1,7 +1,7 @@
 /*
  * ipr.c -- driver for IBM Power Linux RAID adapters
  *
- * Written By: Brian King, IBM Corporation
+ * Written By: Brian King <brking@us.ibm.com>, IBM Corporation
  *
  * Copyright (C) 2003, 2004 IBM Corporation
  *
diff -puN drivers/scsi/ipr.h~ipr_maintainer_email drivers/scsi/ipr.h
--- linux-2.6.8-rc3/drivers/scsi/ipr.h~ipr_maintainer_email	2004-08-04 17:17:25.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.h	2004-08-04 17:17:25.000000000 -0500
@@ -1,7 +1,7 @@
 /*
  * ipr.h -- driver for IBM Power Linux RAID adapters
  *
- * Written By: Brian King, IBM Corporation
+ * Written By: Brian King <brking@us.ibm.com>, IBM Corporation
  *
  * Copyright (C) 2003, 2004 IBM Corporation
  *
_
