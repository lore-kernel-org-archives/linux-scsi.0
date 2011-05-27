From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH] MAINTAINERS update for bnx2fc
Date: Fri, 27 May 2011 11:48:10 -0700
Message-ID: <1306522090-23946-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3712 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab1E0SsS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2011 14:48:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>


Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1868aaf..c238762 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1535,6 +1535,12 @@ L:	linux-wireless@vger.kernel.org
 S:	Supported
 F:	drivers/staging/brcm80211/
 
+BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER
+M:	Bhanu Prakash Gollapudi <bprakash@broadcom.com>
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/bnx2fc/
+
 BROCADE BFA FC SCSI DRIVER
 M:	Jing Huang <huangj@brocade.com>
 L:	linux-scsi@vger.kernel.org
-- 
1.7.0.6


