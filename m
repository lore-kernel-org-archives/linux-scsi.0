From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 01/64] fcoe: Add format spacing to FCOE_NETDEV_DBG debug macro
Date: Tue, 25 Aug 2009 13:58:31 -0700
Message-ID: <20090825205831.1553.95621.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31032 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168AbZHYU6a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 16:58:30 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

There's currently no space between the interface name and the
user specified format/string. This patch adds a space and a colon
to the output to separate the interface name and the user
specified string.

So, instead of "ethXfoo" it will read "ethX: foo".

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index 5ae8ca7..68b9f85 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -61,7 +61,7 @@ do {                                                            	\
 
 #define FCOE_NETDEV_DBG(netdev, fmt, args...)			\
 	FCOE_CHECK_LOGGING(FCOE_NETDEV_LOGGING,			\
-			   printk(KERN_INFO "fcoe: %s" fmt,	\
+			   printk(KERN_INFO "fcoe: %s: " fmt,	\
 				  netdev->name, ##args);)
 
 /*

