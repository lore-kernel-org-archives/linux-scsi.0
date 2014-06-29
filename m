From: Christoph Hellwig <hch@lst.de>
Subject: RFC: clean up command setup
Date: Sun, 29 Jun 2014 15:34:31 +0200
Message-ID: <1404048881-19526-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46555 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbaF2Nc3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jun 2014 09:32:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

There has been some confusion because scsi_setup_blk_pc_cmnd is used to set
up various special TYPE_FS commands.  I've looked into the area and come
up with various cleanup, as well as few small bug fixes that were turned
up by this.

The series is against the core-for-3.17 branch of my scsi-queue tree.

