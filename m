From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/7] [Target_Core_Mod]: Add div64.o to Makefile for
	target_core_mod
Date: Fri, 20 Feb 2009 00:02:14 -0800
Message-ID: <1235116934.12375.1039.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:37369 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753762AbZBTIDU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2009 03:03:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew@wil.cx>, Alan Stern <stern@rowland.harvard.edu>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>

>From f0f3bddaacec544925e72feffb3be1314817c7f9 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 19 Feb 2009 19:35:28 -0800
Subject: [PATCH 3/7] [Target_Core_Mod]: Add div64.o to Makefile for target_core_mod

Add div64.o for __udivdi3() and __umoddi3() to target_core_mod modules objects.
This is now required for FILEIO and RAMDISK subsystem plugins to calculate total
sector/block count from struct file in BYTES and RAMDISK in PAGE_COUNT respectively.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/lio-core/Makefile b/drivers/lio-core/Makefile
index 0b222cf..a171db3 100644
--- a/drivers/lio-core/Makefile
+++ b/drivers/lio-core/Makefile
@@ -40,6 +40,7 @@ target_core_mod-objs			:=	target_core_configfs.o \
 						target_core_tmr.o \
 						target_core_tpg.o \
 						target_core_transport.o \
+						div64.o
 
 ifeq ($(LINUX_IBLOCK), 1)
 target_core_mod-objs			+=	target_core_iblock.o
-- 
1.5.4.1



