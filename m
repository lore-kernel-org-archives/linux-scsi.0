From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: [PATCH] SCSI: includecheck fix: fcoe, libfcoe
Date: Fri, 04 Sep 2009 23:57:56 +0530
Message-ID: <1252088876.6385.14.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:54192 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933686AbZIDSbf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Sep 2009 14:31:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>, Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, scsi <linux-scsi@vger.>


fix the following 'make includecheck' warning:

  drivers/scsi/fcoe/libfcoe.c: linux/netdevice.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/scsi/fcoe/libfcoe.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index f544340..c7d8ca4 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -29,7 +29,6 @@
 #include <linux/ethtool.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
-#include <linux/netdevice.h>
 #include <linux/errno.h>
 #include <linux/bitops.h>
 #include <net/rtnetlink.h>
-- 
1.6.0.6


