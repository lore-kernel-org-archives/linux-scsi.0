From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/2] block: add support for discard limits
Date: Thu, 29 Oct 2009 20:06:59 +0100
Message-ID: <20091029190659.GW10727@kernel.dk>
References: <20091029150830.497006534@bombadil.infradead.org> <20091029151127.257902381@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:43625 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804AbZJ2TGz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Oct 2009 15:06:55 -0400
Content-Disposition: inline
In-Reply-To: <20091029151127.257902381@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, mkp@mkp.net, matthew@wil.cx

On Thu, Oct 29 2009, Christoph Hellwig wrote:
> To properly support discard on SCSI Arrays we need to take the discard
> granularity and the first aligned discard LBA into account.  This patch
> adds block limits for both of them, and trims down dicard requests to fit
> into these limits in blkdev_issue_discard.  We also make sure the alignment
> offset is properly adjust for partitions and add sysfs files to expose
> the limits to userspaced.

Except for a few typos, this looks good to me. I'll add it for 2.6.33.

-- 
Jens Axboe

