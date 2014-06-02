From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 0/4] mpt2/mpt3 static checker fixups
Date: Mon, 2 Jun 2014 10:34:28 -0400
Message-ID: <1401719672-18352-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c12o143.mxlogic.net ([208.65.145.66]:47604 "EHLO
	p01c12o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbaFBOep (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 10:34:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, Joe Lawrence <joe.lawrence@stratus.com>

Hello Sreekanth, Dan,

These are a few minor smatch and sparse static checker fixes for the LSI
mpt2 and mpt3 drivers.  The first three fix real potential bugs and the
last cleans up a noisy complaint from sparse.

Joe Lawrence (4):
  mpt2sas: correct scsi_{target,device} hostdata allocation
  mpt3sas: correct scsi_{target,device} hostdata allocation
  mpt3sas: fix possible memory leak in mpt3sas_send_trigger_data_event
  mpt2sas: annotate ioc->reply_post_host_index as __iomem

 drivers/scsi/mpt2sas/mpt2sas_base.c  |    9 +++++----
 drivers/scsi/mpt2sas/mpt2sas_base.h  |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    6 ++++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   10 +++++++---
 4 files changed, 17 insertions(+), 10 deletions(-)

-- 
1.7.10.4

