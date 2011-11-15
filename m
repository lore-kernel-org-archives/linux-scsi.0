From: akpm@linux-foundation.org
Subject: [patch 1/6] scsi: fix a header to include linux/types.h
Date: Tue, 15 Nov 2011 14:58:06 -0800
Message-ID: <201111152258.pAFMw74D018922@wpaz9.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:57661 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826Ab1KOXDh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2011 18:03:37 -0500
Received: by faap16 with SMTP id p16so26260faa.1
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2011 15:03:36 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, virtuoso@slind.org

From: Alexander Shishkin <virtuoso@slind.org>
Subject: scsi: fix a header to include linux/types.h

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
