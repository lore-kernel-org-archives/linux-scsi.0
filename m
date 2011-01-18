From: akpm@linux-foundation.org
Subject: [patch 2/2] scsi: fix a header to include linux/types.h
Date: Tue, 18 Jan 2011 14:01:32 -0800
Message-ID: <201101182201.p0IM1Xv7007851@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730Ab1ARWBi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 17:01:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, virtuoso@slind.org

From: Alexander Shishkin <virtuoso@slind.org>

For headers that get exported to userland and make use of u32 style
type names, it is advised to include linux/types.h.

This fixes a headers_check warning.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
