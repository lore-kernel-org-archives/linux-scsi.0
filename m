From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/12] nobody loves the advansys driver
Date: Wed,  3 Dec 2014 12:44:53 +0100
Message-ID: <1417607105-85455-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637AbaLCLpM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 06:45:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

it has been bugged me for ages that the advansys driver always
reported a compilation warning about not having been converted
to the DMA-API.
And even aggressive waiting hasn't made this warning go away.

So here's a patchset to update the advansys driver to current
standards and use the DMA-API.
Tested on ABP940-U2W.

As usual, reviews and comments are welcome.

Hannes Reinecke (12):
  advansys: use host_reset
  advansys: use shared host tag map for command lookup
  advansys: use DMA-API for mapping sense buffer
  advansys: Use DMA-API for carrier buffer
  advansys: Use DMA-API for mapping request blocks
  advansys: Use dma_pool for sg elements
  advansys: use 'bool' instead of 'int'
  advansys: use standard data types
  advansys: Remove 'TRUE' and 'FALSE' definitions
  advansys: Remove 'ERR' definition
  advansys: cleanup function return codes
  advansys: Update to version 3.5 and remove compilation warning

 MAINTAINERS             |    1 +
 drivers/scsi/advansys.c | 1073 +++++++++++++++++++++--------------------------
 2 files changed, 469 insertions(+), 605 deletions(-)

-- 
1.8.5.2

