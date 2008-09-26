From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 6/6] bfa: Brocade BFA FC SCSI driver submission (2nd try)
Date: Thu, 25 Sep 2008 18:08:43 -0700
Message-ID: <200809260108.m8Q18hMX028743@swe37.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx40.brocade.com ([144.49.195.4]:6042 "EHLO mx40.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbYIZBIp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2008 21:08:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: huangj@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, srayas@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch contains updated MAINTAINERS file. It is created using
2.6.27-rc7 kernel.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+)

diff -urpN orig/MAINTAINERS patch/MAINTAINERS
--- orig/MAINTAINERS	2008-09-24 13:40:12.000000000 -0700
+++ patch/MAINTAINERS	2008-09-24 13:44:25.000000000 -0700
@@ -995,6 +995,12 @@ M:	mchan@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
 
+BROCADE BFA FC SCSI DRIVER
+P:	Jing Huang 
+M:	huangj@brocade.com
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+
 BSG (block layer generic sg v4 driver)
 P:	FUJITA Tomonori
 M:	fujita.tomonori@lab.ntt.co.jp
