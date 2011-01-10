From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/1] [PATCH] MAINTAINERS: Update zfcp entry
Date: Mon, 10 Jan 2011 11:12:40 +0100
Message-ID: <20110110101751.279496095@de.ibm.com>
References: <20110110101239.295894428@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:53343 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1AJKR4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jan 2011 05:17:56 -0500
Content-Disposition: inline; filename=503-zfcp-maintainer.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, swen@vnet.ibm.com, maier@linux.vnet.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Steffen will take over the zfcp maintainer work. Update the
MAINTAINERS entry accordingly.

Acked-by: Steffen Maier <maier@linux.vnet.ibm.com>
Acked-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -urpN linux-2.6/MAINTAINERS linux-2.6-patched/MAINTAINERS
--- linux-2.6/MAINTAINERS	2011-01-10 10:24:54.000000000 +0100
+++ linux-2.6-patched/MAINTAINERS	2011-01-10 10:25:01.000000000 +0100
@@ -5158,8 +5158,7 @@ S:	Supported
 F:	drivers/s390/crypto/
 
 S390 ZFCP DRIVER
-M:	Christof Schmitt <christof.schmitt@de.ibm.com>
-M:	Swen Schillig <swen@vnet.ibm.com>
+M:	Steffen Maier <maier@linux.vnet.ibm.com>
 M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/

