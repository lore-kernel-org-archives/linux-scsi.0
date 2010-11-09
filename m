From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] tcm/pscsi: HOQ bugfix and cleanups
Date: Mon,  8 Nov 2010 21:41:09 -0800
Message-ID: <1289281269-20432-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp109.sbc.mail.gq1.yahoo.com ([67.195.14.39]:34607 "HELO
	smtp109.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751896Ab0KIFlO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2010 00:41:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings folks,

This short series addresses three items found by Boaz during review of the
TCM/pSCSI backend code from last week.  This patch is being pushed into
lio-core-2.6.git/lio-4.0 shortly.

Many thanks to Boaz for this comments here, and catching the HOQ bug with
blk_execute_rq_nowait().

Thanks you!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  tcm/pscsi: Fix incorrect usage of head_of_queue with
    blk_execute_rq_nowait()
  tcm/pscsi: Drop unnecessary struct pscsi_plugin_task->pscsi_req_bidi
  tcm/pscsi: Remove legacy struct scsi_device->sector_size workaround
    for TYPE_DISK

 drivers/target/target_core_pscsi.c |   58 ++++++++---------------------------
 drivers/target/target_core_pscsi.h |    1 -
 2 files changed, 14 insertions(+), 45 deletions(-)

