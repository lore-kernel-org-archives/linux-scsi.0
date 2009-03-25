From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/5] [Target_Core_Mod]: Add TMR LUN_RESET, REQUEST_SENSE
	and TAS support
Date: Tue, 24 Mar 2009 22:51:54 -0700
Message-ID: <1237960314.4138.392.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:37881 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752734AbZCYFwB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 01:52:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Greetings all,

This patch adds support for TMR LUN_RESET with TASK ABORTED status Enabled/Disabled.
It also adds initial support for REQUEST_SENSE.  They have been tested with sg_reset issuing
LUN_RESET from iSCSI LUNs across multiple Open-iSCSI Sessions.

These patches are made against lio-core-2.6.git/master and tested on
v2.6.29 x86 32-bit HVM using sg_persist from sg3_utils.  The lio-core-2.6.git tree
can be found at: 

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

[PATCH 1/5] [Target_Core_Mod]: Add emulated REQUEST_SENSE and Control mode page TAS bit
[PATCH 2/5] [Target_Core_Mod]: Add REQUEST_SENSE usage subsystem plugins
[PATCH 3/5] [Target_Core_Mod/ConfigFS]: Add emulated_tas READ/WRITE device attribute
[PATCH 4/5] [Target_Core_Mod]: Add support for TMR LUN_RESET w/ Task Aborted Status (TAS)
[PATCH 5/5] [LIO-Target]: Update core_tmr_alloc_req() usage

--nab


