From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] Add ConfigFS enabled write_protect support to
	LIO-Target
Date: Wed, 03 Dec 2008 20:34:44 -0800
Message-ID: <1228365284.4153.105.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:42627 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751659AbYLDEer (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 23:34:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Greetings all,

This patch series adds support for turning on LUN level SCSI WRITE-Protect
for iSCSI Target Portal Groups (TPGs) and iSCSI Initiator LUN ACLs in
the Linux-iSCSI.org Target (LIO-Target).  They are made against against
lio-core-2.6.git/master and tested on v2.6.28-rc7.

[PATCH 1/3] [LIO-Target]: Update for iSCSI Initiator LUN ACLs using write_protect
[PATCH 2/3] [LIO-Target]: Add TPG attributes demo_mode_write_protect and prod_mode_write_protect
[PATCH 3/3] [LIO-Target/ConfigFS]: Add Target Portal Group *_write_protect attributes and iSCSI LUN ACL write_protect bit

The lio-core-2.6.git is located at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Comments are appericated,

--nab

