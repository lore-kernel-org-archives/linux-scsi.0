From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: clean up command setup
Date: Fri, 11 Jul 2014 02:16:07 -0700
Message-ID: <20140711091607.GA26912@infradead.org>
References: <1404048881-19526-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48314 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaGKJQJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jul 2014 05:16:09 -0400
Content-Disposition: inline
In-Reply-To: <1404048881-19526-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Sun, Jun 29, 2014 at 03:34:31PM +0200, Christoph Hellwig wrote:
> There has been some confusion because scsi_setup_blk_pc_cmnd is used to set
> up various special TYPE_FS commands.  I've looked into the area and come
> up with various cleanup, as well as few small bug fixes that were turned
> up by this.
> 
> The series is against the core-for-3.17 branch of my scsi-queue tree.

I'd like to drop the RFC and officially propose this for inclusion.  As
noted elsewhere this also helps as a preparation for handling the WRITE
SAME and discard requests properly for scsi-mq, so I'd love to get some
reviews for it, and will report scsi-mq on top of it.
