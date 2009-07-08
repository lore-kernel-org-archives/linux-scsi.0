From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: [PATCH 27/44] includecheck fix: drivers/scsi, libfcoe.c
Date: Wed, 08 Jul 2009 20:58:56 +0530
Message-ID: <1247066936.4382.76.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:53173 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758492AbZGHQEG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2009 12:04:06 -0400
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, scsi <linux-scsi@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>


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



