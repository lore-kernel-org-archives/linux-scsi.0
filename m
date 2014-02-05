From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/15] A different approach for using blk-mq in the SCSI layer
Date: Wed, 05 Feb 2014 04:41:18 -0800
Message-ID: <20140205124118.332902571@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53213 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaBEMlx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:41:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

As explained in my earlier proposal I think we need to move to blk-mq
for the SCSI midlayer quickly, and in a way that keeps all the existing
queueing mechanisms working.  This series shows my current progress towards
this goal.  It works under medium loads for iSCSI and virtio_scsi and I'm
fairly happy with the code structure.  As seen I've tried to push as much
work into the blk-mq core, and refactor the SCSI code so that it can be
used for the old request based path and blk-mq as much as possible.

There are still lots of limits mostly due to the lack of functionality in
blk-mq, and I will try to address these in the blk-mq core mostly.

A git tree is also available at

  git://git.infradead.org/users/hch/scsi.git#scsi-mq-wip

This work was sponsored by the ION division of Fusion IO.
