From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 2/7] megaraid_sas : Update MAINTAINERS for megaraid
 drivers
Date: Mon, 10 Nov 2014 17:51:19 +0530
Message-ID: <201411101224.sAACOhj1018043@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0083.outbound.protection.outlook.com ([207.46.100.83]:39133
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752298AbaKJMgi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2014 07:36:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, aradford@gmail.com

Update MAINTAINERS list for megaraid_sas driver

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 MAINTAINERS |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index aefa948..94c393f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5830,10 +5830,14 @@ W:	http://linuxtv.org
 S:	Odd Fixes
 F:	drivers/media/parport/pms*
 
-MEGARAID SCSI DRIVERS
-M:	Neela Syam Kolli <megaraidlinux@lsi.com>
+MEGARAID SCSI/SAS DRIVERS
+M:	Adam Radford <adam.radford@avagotech.com>
+M:	Kashyap Desai <kashyap.desai@avagotech.com>
+M:	Sumit Saxena <sumit.saxena@avagotech.com>
+M:	Uday Lingala <uday.lingala@avagotech.com>
+L:	megaraidlinux.pdl@avagotech.com
 L:	linux-scsi@vger.kernel.org
-W:	http://megaraid.lsilogic.com
+W:	http://www.lsi.com
 S:	Maintained
 F:	Documentation/scsi/megaraid.txt
 F:	drivers/scsi/megaraid.*
-- 
1.7.1

