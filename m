From: Christoph Hellwig <hch@lst.de>
Subject: integrate scsi_dh better into the scsi core V2
Date: Sun, 10 May 2015 20:40:52 +0200
Message-ID: <1431283260-13406-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52210 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbbEJSmO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 May 2015 14:42:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

This series ties scsi_dh deeper into the scsi core, and fixes all kinds
of issues in it, most importantly the race between using and detaching
device handlers.

Changes since V1:
  - updated comments / strings based on review feedback
  - moved scsi_dh.c to drivers/scsi to fix the srcdir = objdir build
  - changed the old patch 2 to have saner handling of mismatching device
    handlers in dm.
  - dropped patch 1: not having a hw handler is fine if we don't plan to
    change it anyway
  - dropped patch 3: not necessary anymore.

