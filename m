From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 5/5] bfa: Brocade BFA FC SCSI driver submission
Date: Tue, 27 Jan 2009 10:55:58 -0800
Message-ID: <200901271855.n0RItwOP026944@swe37.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx30.brocade.com ([144.49.194.4]:60661 "EHLO mx30.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757194AbZA0S7Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2009 13:59:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch contains updated MAINTAINERS file. It is created using
2.6.29-rc2 kernel.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+)

diff -urpN orig/MAINTAINERS patch/MAINTAINERS
--- orig/MAINTAINERS	2009-01-26 17:28:27.000000000 -0800
+++ patch/MAINTAINERS	2009-01-26 17:28:27.000000000 -0800
@@ -1009,6 +1009,12 @@ M:	mchan@broadcom.com
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
