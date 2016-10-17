From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] smartpqi: switch to pci_alloc_irq_vectors
Date: Mon, 17 Oct 2016 16:20:36 +0200
Message-ID: <20161017142036.GA17678@lst.de>
References: <1476521241-32765-1-git-send-email-hch@lst.de> <1476521241-32765-4-git-send-email-hch@lst.de> <20161017073428.27xzw6du4j3r4qro@linux-x5ow.site> <4993A297653ECB4581FA5C3C31323D193B070B79@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59096 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754663AbcJQOUj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 10:20:39 -0400
Content-Disposition: inline
In-Reply-To: <4993A297653ECB4581FA5C3C31323D193B070B79@avsrvexchmbx1.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

Hi Don,

did you also have a chance to test the patch and verify that the
queues are properly set up with a smartpqi controller?
