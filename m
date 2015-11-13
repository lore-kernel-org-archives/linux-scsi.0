From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3/3] MAINTAINERS: Add myself as co-maintainer of the SCSI subsystem.
Date: Fri, 13 Nov 2015 16:46:49 -0500
Message-ID: <1447451209-30772-3-git-send-email-martin.petersen@oracle.com>
References: <1447451209-30772-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27287 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbbKMVrV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Nov 2015 16:47:21 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tADLlLJI029714
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2015 21:47:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id tADLlLhr006070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2015 21:47:21 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id tADLlKLA032549
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2015 21:47:21 GMT
In-Reply-To: <1447451209-30772-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 MAINTAINERS | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9de185da5f5b..978df6e36ddf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9205,8 +9205,10 @@ F:	include/scsi/sg.h
 
 SCSI SUBSYSTEM
 M:	"James E.J. Bottomley" <JBottomley@odin.com>
-L:	linux-scsi@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
+M:	"Martin K. Petersen" <martin.petersen@oracle.com>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
+L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/
 F:	include/scsi/
-- 
2.4.3

