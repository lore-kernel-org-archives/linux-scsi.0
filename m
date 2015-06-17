From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] [PATCH] block: Add blk_max_rw_sectors limit
Date: Wed, 17 Jun 2015 03:33:15 -0700
Message-ID: <20150617103315.GA7475@infradead.org>
References: <201506151902.t5FJ2giY001071@d01av01.pok.ibm.com>
 <yq1616nff0p.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54794 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbbFQKdU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2015 06:33:20 -0400
Content-Disposition: inline
In-Reply-To: <yq1616nff0p.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, hch@infradead.org, axboe@kernel.dk

On Tue, Jun 16, 2015 at 06:46:14PM -0400, Martin K. Petersen wrote:
> 
> Brian,
> 
> I only have minor nits wrt. your patch since you did what I asked.
> However, now that I'm less jet lagged and blurry eyed I wonder if
> the tweak below wouldn't suffice?

This would be my preferred version as well.
