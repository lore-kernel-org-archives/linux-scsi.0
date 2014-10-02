From: Hannes Reinecke <hare@suse.de>
Subject: [RFC PATCH 0/5] Remove scmd->tag
Date: Thu,  2 Oct 2014 12:43:08 +0200
Message-ID: <1412246593-107001-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbaJBKnQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2014 06:43:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Webb Scales <webbnh@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The 'tag' field of struct scsi_cmnd has not separate meaning anymore,
and the same information is present in the associated request.
So remove it.

Hannes Reinecke (5):
  NCR5380: Whitespace cleanup
  scsi: Remove references to linked commands
  vmw_pvscsi: fixup tagging
  tcm_loop: Fixup tag handling
  scsi: Remove scmd->tag

 drivers/scsi/NCR5380.c             | 691 ++++++++++++++++++-------------------
 drivers/scsi/atari_NCR5380.c       |  57 ---
 drivers/scsi/fnic/fnic_scsi.c      |   1 -
 drivers/scsi/scsi_lib.c            |   4 -
 drivers/scsi/sun3_NCR5380.c        |  57 ---
 drivers/scsi/vmw_pvscsi.c          |   5 +-
 drivers/target/loopback/tcm_loop.c |  23 +-
 include/scsi/scsi_cmnd.h           |   2 -
 8 files changed, 342 insertions(+), 498 deletions(-)

-- 
1.8.5.2

