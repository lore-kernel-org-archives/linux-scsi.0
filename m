From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/2] zfcp: Update MAINTAINERS entry
Date: Thu, 01 Apr 2010 13:04:07 +0200
Message-ID: <20100401110549.849117000@de.ibm.com>
References: <20100401110406.973537000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:38745 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab0DALFv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2010 07:05:51 -0400
Content-Disposition: inline; filename=700-zfcp-update-maintainers.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Martin Peschke <mp3@de.ibm.com>, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Martin no longer works on zfcp, remove his entry from the MAINTAINERS
file and add Swen as co-maintainer.

Also remove the reference to the zfcpdump.txt file, zfcpdump is not
part of the zfcp device driver.

Cc: Martin Peschke <mp3@de.ibm.com>
Cc: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/MAINTAINERS	2010-04-01 12:17:08.000000000 +0200
+++ b/MAINTAINERS	2010-04-01 12:22:54.000000000 +0200
@@ -4776,12 +4776,11 @@ F:	drivers/s390/crypto/
 
 S390 ZFCP DRIVER
 M:	Christof Schmitt <christof.schmitt@de.ibm.com>
-M:	Martin Peschke <mp3@de.ibm.com>
+M:	Swen Schillig <swen@vnet.ibm.com>
 M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
-F:	Documentation/s390/zfcpdump.txt
 F:	drivers/s390/scsi/zfcp_*
 
 S390 IUCV NETWORK LAYER

