From: akpm@osdl.org
Subject: [patch 01/28] megaraid: unused variable
Date: Wed, 08 Mar 2006 00:14:17 -0800
Message-ID: <200603080816.k288G6IP002150@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:13484 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1752092AbWCHIQK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:16:10 -0500
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
--- devel/drivers/scsi/megaraid.c~megaraid-unused-variable	2006-02-07 13:19:07.000000000 -0800
+++ devel-akpm/drivers/scsi/megaraid.c	2006-02-07 13:19:07.000000000 -0800
@@ -4470,7 +4470,6 @@ mega_internal_command(adapter_t *adapter
 {
 	Scsi_Cmnd	*scmd;
 	struct	scsi_device *sdev;
-	unsigned long	flags = 0;
 	scb_t	*scb;
 	int	rval;
 
_
