From: Christoph Hellwig <hch@lst.de>
Subject: Testers needed: "new" driver advansys for advansys wide scsi boards
Date: Sun, 27 Jun 2004 19:51:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040627175138.GA3160@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:31894 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264524AbUF0Rvs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jun 2004 13:51:48 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: trini@kernel.crashing.org, linux-scsi@vger.kernel.org

Okay, I've looked through the advansys driver, and it's really two
drivers for hardware that has nothing in common (narrow vs wide boards).

I've started with a new "adv" driver for only the wide drivers, except
the split the major changes over advansys.c are that the internal
queueing is gone and it uses proper pci probing.  If this driver works
okay I'd like to finish the dma api conversion as a next step.

Unfortunately I don't have advansys hardware myself (yet) so I need
testers for it..

The gzipped patch is at http://verein.lst.de/~hch/adv.diff.gz
