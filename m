From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/18] ALUA device handler update, part 1
Date: Fri, 20 Nov 2015 11:54:33 +0100
Message-ID: <20151120105433.GA25084@lst.de>
References: <1447081703-110552-1-git-send-email-hare@suse.de> <20151120104710.GA24871@lst.de> <564EFB65.6050603@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40999 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759577AbbKTKyk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2015 05:54:40 -0500
Content-Disposition: inline
In-Reply-To: <564EFB65.6050603@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.com>, Ewan Milne <emilne@redhat.com>

On Fri, Nov 20, 2015 at 11:52:21AM +0100, Hannes Reinecke wrote:
> One thing, though: I don't really agree with Barts objection that
> moving to a workqueue would tie in too many resources.
> Thing is, I'm not convinces that using a work queue is allocating
> too many resources (we're speaking of 460 vs 240 bytes here).
> Also we have to retry commands for quite some time (cite the
> infamous NetApp takeover/giveback, which can take minutes).
> If we were to handle that without workqueue we'd have to initiate
> the retry from the end_io callback, causing a quite deep stack
> recursion. Which I'm not really fond of.
> 
> But if anyone has a better idea on how to handle retries without the
> need for workqueues I'm all ears :-)

I tend to agree with you, but you better warm up that discussion again
on the old thread that actually has Bart on Cc.  Or just resend once
Martin has merged this patch, and have discussion around that version.
