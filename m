From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 5/5] bfa: Brocade BFA FC SCSI driver (maint)
Date: Sat, 14 Mar 2009 12:59:52 -0700
Message-ID: <200903141959.n2EJxq93030549@blc-10-6.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx10.brocade.com ([208.185.105.18]:25562 "EHLO mx10.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbZCNUAG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Mar 2009 16:00:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch contains updated MAINTAINERS file. It is created using
2.6.29-rc8 kernel.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+)

diff -urpN orig/MAINTAINERS patch/MAINTAINERS
--- orig/MAINTAINERS	2009-03-14 11:45:01.265599000 -0700
+++ patch/MAINTAINERS	2009-03-14 11:45:01.244760000 -0700
@@ -1016,6 +1016,12 @@ M:	mchan@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
 
+BROCADE BFA FC SCSI DRIVER
+P:     Jing Huang
+M:     huangj@brocade.com
+L:     linux-scsi@vger.kernel.org
+S:     Supported
+
 BSG (block layer generic sg v4 driver)
 P:	FUJITA Tomonori
 M:	fujita.tomonori@lab.ntt.co.jp
