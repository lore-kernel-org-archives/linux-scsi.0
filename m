From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/5] convert sg to use the block layer
Date: Thu, 28 Aug 2008 09:07:25 +0200
Message-ID: <20080828070725.GP20055@kernel.dk>
References: <20080826075627.GU20055@kernel.dk> <20080827111425Y.fujita.tomonori@lab.ntt.co.jp> <20080827071018.GX20055@kernel.dk> <20080828082601S.fujita.tomonori@lab.ntt.co.jp> <20080828065147.GO20055@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:53190 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbYH1HH2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2008 03:07:28 -0400
Content-Disposition: inline
In-Reply-To: <20080828065147.GO20055@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

On Thu, Aug 28 2008, Jens Axboe wrote:
> On Thu, Aug 28 2008, FUJITA Tomonori wrote:
> > On Wed, 27 Aug 2008 09:10:18 +0200
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > > Thanks, I put an updated version against the for-2.6.28 branch in your
> > > > tree:
> > > > 
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git sg-block
> > > > 
> > > > 
> > > > Can you wait for a little while before applying this to your
> > > > for-2.6.28 branch? We need Doug's ACK on this.
> > > 
> > > Sure, just let me know...
> > 
> > Now we got Doug's ACK on this (Doug, thanks!). Can you apply them to
> > your for-2.6.28 branch? I'll resend them if necessary.
> 
> Yes certainly. No need to resend, I'll add Dougs ack and merge it.

Actually, the previous was against for-linus (not for-2.6.28), so if you
could resend against 2.6.28 that would help a lot. Thanks!

-- 
Jens Axboe

