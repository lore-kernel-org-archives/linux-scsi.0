From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] fusion: fix recent kernel-doc problems
Date: Sat, 13 Jun 2009 19:37:18 -0700
Message-ID: <4A34625E.90903@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:43971 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbZFNChc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Jun 2009 22:37:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, Eric.Moore@lsi.com, support@lsi.com, DL-MPTFusionLinux@lsi.com

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix recent fusion driver kernel-doc fatal error and warnings.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric.Moore@lsi.com
Cc: support@lsi.com
Cc: DL-MPTFusionLinux@lsi.com
---
 drivers/message/fusion/mptbase.c  |    3 +--
 drivers/message/fusion/mptscsih.c |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

--- linux-2.6.30-git7.orig/drivers/message/fusion/mptbase.c
+++ linux-2.6.30-git7/drivers/message/fusion/mptbase.c
@@ -1023,8 +1023,7 @@ mpt_add_sge_64bit(void *pAddr, u32 flags
 }
 
 /**
- *	mpt_add_sge_64bit_1078 - Place a simple 64 bit SGE at address pAddr
- *	(1078 workaround).
+ *	mpt_add_sge_64bit_1078 - Place a simple 64 bit SGE at address pAddr (1078 workaround).
  *	@pAddr: virtual address for SGE
  *	@flagslength: SGE flags and data transfer length
  *	@dma_addr: Physical address
--- linux-2.6.30-git7.orig/drivers/message/fusion/mptscsih.c
+++ linux-2.6.30-git7/drivers/message/fusion/mptscsih.c
@@ -2675,8 +2675,8 @@ mptscsih_timer_expired(unsigned long dat
 /**
  *	mptscsih_get_completion_code -
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	@reply:
- *	@cmd:
+ *	@req: Pointer to original MPT request frame
+ *	@reply: Pointer to MPT reply frame (NULL if TurboReply)
  *
  **/
 static int
