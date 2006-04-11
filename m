From: akpm@osdl.org
Subject: [patch 01/15] megaraid: unused variable
Date: Mon, 10 Apr 2006 23:26:03 -0700
Message-ID: <200604110726.k3B7QjBb015265@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:42375 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932221AbWDKH0z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Apr 2006 03:26:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org


From: Andrew Morton <akpm@osdl.org>

drivers/scsi/megaraid.c: In function `mega_internal_command':
drivers/scsi/megaraid.c:4474: warning: unused variable `flags'


Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/megaraid.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/scsi/megaraid.c~megaraid-unused-variable drivers/scsi/megaraid.c
--- devel/drivers/scsi/megaraid.c~megaraid-unused-variable	2006-04-05 21:27:55.000000000 -0700
+++ devel-akpm/drivers/scsi/megaraid.c	2006-04-05 21:27:55.000000000 -0700
@@ -4471,7 +4471,6 @@ mega_internal_command(adapter_t *adapter
 {
 	Scsi_Cmnd	*scmd;
 	struct	scsi_device *sdev;
-	unsigned long	flags = 0;
 	scb_t	*scb;
 	int	rval;
 
_
