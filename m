From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH] MAINTAINERS: zfcp
Date: Tue, 18 Dec 2007 11:16:14 +0100
Message-ID: <200712181116.14381.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:60406 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbXLRKQP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Dec 2007 05:16:15 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Christof Schmitt <christof.schmitt@de.ibm.com>, Martin Peschke <mp3@de.ibm.com>

James

we are planning a major rewrite of the zfcp driver, 
meaning that a lot of patches will hit the mailing-list in the near future.

Since I can't support this additional work-load along with my other 
responsibilities we are shifting the maintainership to
Christof Schmitt as the maintainer and
Martin Peschke as the co-maintainer.

Please support the two in providing us a new and more stable
zfcp environment.

Thanks
Swen

---
 MAINTAINERS |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: scsi-misc/MAINTAINERS
===================================================================
--- scsi-misc.orig/MAINTAINERS
+++ scsi-misc/MAINTAINERS
@@ -3246,8 +3246,10 @@ W:	http://www.ibm.com/developerworks/lin
 S:	Supported
 
 S390 ZFCP DRIVER
-P:	Swen Schillig
-M:	swen@vnet.ibm.com
+P:	Christof Schmitt
+M:	christof.schmitt@de.ibm.com
+P:	Martin Peschke
+M:	mp3@de.ibm.com
 M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
