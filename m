From: Alexander Shishkin <virtuoso@slind.org>
Subject: [PATCH 3/4] scsi: fix a header to include linux/types.h
Date: Wed,  1 Dec 2010 17:10:44 +0200
Message-ID: <1291216245-18574-4-git-send-email-virtuoso@slind.org>
References: <1291216245-18574-1-git-send-email-virtuoso@slind.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1291216245-18574-1-git-send-email-virtuoso@slind.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Shishkin <virtuoso@slind.org>, Andrew Morton <akpm@linux-foundation.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

For headers that get exported to userland and make use of u32 style
type names, it is advised to include linux/types.h.

This fixes a headers_check warning.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: "James E.J. Bottomley" <James.Bottomley@suse.de>
CC: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 include/scsi/scsi_netlink.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/scsi/scsi_netlink.h b/include/scsi/scsi_netlink.h
index 58ce8fe..5cb20cc 100644
--- a/include/scsi/scsi_netlink.h
+++ b/include/scsi/scsi_netlink.h
@@ -23,7 +23,7 @@
 #define SCSI_NETLINK_H
 
 #include <linux/netlink.h>
-
+#include <linux/types.h>
 
 /*
  * This file intended to be included by both kernel and user space
-- 
1.7.2.1.45.gb66c2
