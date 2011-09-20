From: akpm@google.com
Subject: [patch 1/8] scsi: fix a header to include linux/types.h
Date: Tue, 20 Sep 2011 14:20:05 -0700
Message-ID: <201109202120.p8KLK5CW019714@hpaq2.eem.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:2708 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1ITVUS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Sep 2011 17:20:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@google.com, virtuoso@slind.org

From: Alexander Shishkin <virtuoso@slind.org>
Subject: scsi: fix a header to include linux/types.h

For headers that get exported to userland and make use of u32 style
type names, it is advised to include linux/types.h.

This fixes a headers_check warning.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 include/scsi/scsi_netlink.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/scsi/scsi_netlink.h~scsi-fix-a-header-to-include-linux-typesh include/scsi/scsi_netlink.h
--- a/include/scsi/scsi_netlink.h~scsi-fix-a-header-to-include-linux-typesh
+++ a/include/scsi/scsi_netlink.h
@@ -23,7 +23,7 @@
 #define SCSI_NETLINK_H
 
 #include <linux/netlink.h>
-
+#include <linux/types.h>
 
 /*
  * This file intended to be included by both kernel and user space
_
