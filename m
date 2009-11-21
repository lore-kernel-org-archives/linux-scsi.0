From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] block: Allow devices to indicate whether discarded
	blocks are zeroed
Date: Sat, 21 Nov 2009 05:13:56 -0500
Message-ID: <20091121101356.GA21716@infradead.org>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com> <1258771524-26673-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44690 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbZKUKOA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Nov 2009 05:14:00 -0500
Content-Disposition: inline
In-Reply-To: <1258771524-26673-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, hch@infradead.org, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Nov 20, 2009 at 09:45:21PM -0500, Martin K. Petersen wrote:
> The discard ioctl is used by mkfs utilities to clear a block device
> prior to putting metadata down.  However, not all devices return zeroed
> blocks after a discard.  Some drives return stale data, potentially
> containing old superblocks.  It is therefore important to know whether
> discarded blocks are properly zeroed.

At least for mkfs.xfs we make sure to still zero the important areas
after the TRIM ioctl anyway.

