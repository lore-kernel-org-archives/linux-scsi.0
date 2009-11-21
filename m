From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/4] block: Allow devices to indicate whether discarded
	blocks are zeroed
Date: Sat, 21 Nov 2009 12:58:03 -0700
Message-ID: <20091121195802.GC8502@parisc-linux.org>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com> <1258771524-26673-2-git-send-email-martin.petersen@oracle.com> <20091121101356.GA21716@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37865 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbZKUT55 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Nov 2009 14:57:57 -0500
Content-Disposition: inline
In-Reply-To: <20091121101356.GA21716@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, Nov 21, 2009 at 05:13:56AM -0500, Christoph Hellwig wrote:
> On Fri, Nov 20, 2009 at 09:45:21PM -0500, Martin K. Petersen wrote:
> > The discard ioctl is used by mkfs utilities to clear a block device
> > prior to putting metadata down.  However, not all devices return zeroed
> > blocks after a discard.  Some drives return stale data, potentially
> > containing old superblocks.  It is therefore important to know whether
> > discarded blocks are properly zeroed.
> 
> At least for mkfs.xfs we make sure to still zero the important areas
> after the TRIM ioctl anyway.

Could you change that to zero _before_ the TRIM?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
