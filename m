From: Adam Borowski <kilobyte@angband.pl>
Subject: [PATCH] scsi: aic7xxx: explain a mysterious build failure message
Date: Mon,  9 Oct 2017 22:11:02 +0200
Message-ID: <20171009201102.5752-1-kilobyte@angband.pl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:33829 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752528AbdJIULV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2017 16:11:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>

"*** Install db development libraries" doesn't ring a bell that it's talking
about libdb (Berkeley DB).  Because of BDB's relicensing to Affero,
incompatible with many users including Linux, most if not all distributions
can be expected to keep version 5.3 for the foreseable future, thus we can
point the user directly to libdb5.3-dev as the package to install.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 drivers/scsi/aic7xxx/aicasm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aicasm/Makefile b/drivers/scsi/aic7xxx/aicasm/Makefile
index 45e2d49c1fff..e69ceb71beb7 100644
--- a/drivers/scsi/aic7xxx/aicasm/Makefile
+++ b/drivers/scsi/aic7xxx/aicasm/Makefile
@@ -54,7 +54,7 @@ $(OUTDIR)/aicdb.h:
 	 elif [ -e "/usr/include/db_185.h" ]; then		\
 		echo "#include <db_185.h>" > $@;		\
 	 else							\
-		echo "*** Install db development libraries";	\
+		echo "*** Install libdb development libraries (usually libdb5.3-dev)";\
 	 fi
 
 clean:
-- 
2.14.2
