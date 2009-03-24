From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 5/5] bfa: Brocade BFA FC SCSI driver (maint)
Date: Mon, 23 Mar 2009 17:12:57 -0700
Message-ID: <200903240012.n2O0CvRX014252@blc-10-2.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx40.brocade.com ([144.49.195.4]:46774 "EHLO mx40.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbZCXAQH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Mar 2009 20:16:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: huangj@brocade.com, kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Krishna Chaitanya Gudipati <kgudipat@brocade.com>

This patch contains updated MAINTAINERS file.

Signed-off-by: Krishna Chaitanya Gudipati <kgudipat@brocade.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+)

diff -urpN orig/MAINTAINERS patch/MAINTAINERS
--- orig/MAINTAINERS	2009-03-23 15:33:17.121013000 -0700
+++ patch/MAINTAINERS	2009-03-23 15:33:17.101362000 -0700
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
