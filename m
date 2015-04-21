From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: RFC: struct request cleanups
Date: Tue, 21 Apr 2015 15:51:42 -0400
Message-ID: <20150421195142.GX4003@linux.intel.com>
References: <1429303042-12078-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50627 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932380AbbDUTvp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 15:51:45 -0400
Content-Disposition: inline
In-Reply-To: <1429303042-12078-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Fri, Apr 17, 2015 at 10:37:15PM +0200, Christoph Hellwig wrote:
> The real RFC is the last one which allocates the block_pc specific
> data separately in the callers instead of bloating every struct
> request with it.  I always hated what we did, but with the upcoming
> split of nvme into transports and command sets we'll need a NVME
> equivalent of BLOCK_PC, and as NVMe was designed by crackmonkeys
> dreaming of an ATA controller the "command block" for NVME is even
> bigger than what we have to deal with in SCSI.

Umm, the NVMe command was never supposed to be "transported".  The
crackmonkeys are the ones who are trying to ship it across the network
instead of designing a proper network protocol.
