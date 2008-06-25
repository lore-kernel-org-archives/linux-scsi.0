From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Wed, 25 Jun 2008 11:34:44 -0600
Message-ID: <20080625173444.GS4392@parisc-linux.org>
References: <20080619160342.GJ4392@parisc-linux.org> <20080625134705.GZ20851@kernel.dk> <4862552A.5010900@gmail.com> <48627184.9010609@panasas.com> <20080625165759.GC20851@kernel.dk> <20080625172015.GR4392@parisc-linux.org> <20080625172638.GE20851@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:46004 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbYFYRfA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2008 13:35:00 -0400
Content-Disposition: inline
In-Reply-To: <20080625172638.GE20851@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Ric Wheeler <ricwheeler@gmail.com>, linux-scsi@vger.kernel.org

On Wed, Jun 25, 2008 at 07:26:39PM +0200, Jens Axboe wrote:
> Uhm, but it IS "a blatant layering violation", it's doing things from
> the wrong side up :-)

That's just "doing things from a spot Jens doesn't approve of".  A
layering violation would be SCSI knowing how elevators work.

> I don't think udev is a particularly good idea either. My plan was to
> introduce device profiles for the queue, but it is probably a bad idea
> to over-engineer this. So I'll keep it simple, stick to a 'zero cost
> seek' flag instead and allow drivers to signal that. libata/ide needs to
> check the ID page word to detect SSD drives as well, so they need a few
> lines of change too.

One of the other patches in this mess was the libata piece to translate
ATA8's rotation speed to SCSI's b1 VPD page, so ide is the only
remaining work left to do (can't it die already?)

> I'll just stick the block bit in the 2.6.27 pending queue and let the
> other patches go through Jeff/James/Bart.

Thanks.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
