From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/2] scsi discard support
Date: Thu, 29 Oct 2009 11:08:30 -0400
Message-ID: <20091029150830.497006534@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59916 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852AbZJ2PLX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2009 11:11:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mkp@mkp.net, axboe@kernel.dk, matthew@wil.cx

Time for proper scsi discard support.  The first patch is for the block layer
to implement the discard granularity limits properly.  The second is a SPC3r20
compliant implementation sending WRITE SAME with the unmap bit from sd.

ATA support will come later now that I finally obtained a TRIM capable OCZ SSD.

So far only tested using Martin's scsi_debug TP support and my experimental
qemu TP support, but I'll be able to test it on some real arrays soon.
