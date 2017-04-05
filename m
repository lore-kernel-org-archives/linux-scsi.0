From: Christoph Hellwig <hch@lst.de>
Subject: ->retries fixups
Date: Wed,  5 Apr 2017 16:18:51 +0200
Message-ID: <20170405141856.1862-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49462 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752993AbdDEOTG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 10:19:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>
Cc: linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

This series fixes a few lose bits in terms of how nvme uses ->retries,
including fixing it for non-PCIe transports.  While at it I noticed that
nvme and scsi use the field in entirely different ways, and no other
driver uses it at all.  So I decided to move it into the nvme_request and
scsi_request structures instead.
