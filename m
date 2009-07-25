From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 14/14] bfa: Brocade BFA FC SCSI driver (maint)
Date: Fri, 24 Jul 2009 23:26:09 -0700
Message-ID: <200907250626.n6P6Q98A026194@swe57.brocade.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755116AbZGYG0N@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com
List-Id: linux-scsi@vger.kernel.org

From: Jing Huang <huangj@brocade.com>

This patch contains updated MAINTAINERS file.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+)

diff -urpN orig/MAINTAINERS patch/MAINTAINERS
--- orig/MAINTAINERS	2009-07-21 15:34:07.000000000 -0700
+++ patch/MAINTAINERS	2009-07-21 15:34:07.000000000 -0700
@@ -1254,6 +1254,13 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/tg3.*
 
+BROCADE BFA FC SCSI DRIVER
+P:	Jing Huang
+M:	huangj@brocade.com
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/bfa/
+
 BSG (block layer generic sg v4 driver)
 P:	FUJITA Tomonori
 M:	fujita.tomonori@lab.ntt.co.jp
