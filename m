From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 3/3] MAINTAINERS: Update maintainer list for bnx2i and bnx2fc
Date: Thu, 3 Jul 2014 08:18:29 -0400
Message-ID: <1404389909-15319-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1404389909-15319-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:38864 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752782AbaGCMxJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 08:53:09 -0400
In-Reply-To: <1404389909-15319-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: vikas.chaudhary@qlogic.com, giridhar.malavali@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Acked-by: Eddie Wai <eddie.wai@broadcom.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2482eee..dec99fb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1943,13 +1943,13 @@ S:	Supported
 F:	drivers/net/wireless/brcm80211/
 
 BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER
-M:	Eddie Wai <eddie.wai@broadcom.com>
+M:	QLogic-Storage-Upstream@qlogic.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/bnx2fc/
 
 BROADCOM BNX2I 1/10 GIGABIT iSCSI DRIVER
-M:	Eddie Wai <eddie.wai@broadcom.com>
+M:	QLogic-Storage-Upstream@qlogic.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/bnx2i/
-- 
1.8.2.GIT

