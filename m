From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/5] convert sg to use the block layer
Date: Thu, 28 Aug 2008 16:32:47 +0900
Message-ID: <20080828163241N.fujita.tomonori@lab.ntt.co.jp>
References: <20080828082601S.fujita.tomonori@lab.ntt.co.jp>
	<20080828065147.GO20055@kernel.dk>
	<20080828070725.GP20055@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:45065 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbYH1HdI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2008 03:33:08 -0400
In-Reply-To: <20080828070725.GP20055@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

On Thu, 28 Aug 2008 09:07:25 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Aug 28 2008, Jens Axboe wrote:
> > On Thu, Aug 28 2008, FUJITA Tomonori wrote:
> > > On Wed, 27 Aug 2008 09:10:18 +0200
> > > Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > > > Thanks, I put an updated version against the for-2.6.28 branch in your
> > > > > tree:
> > > > > 
> > > > > git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git sg-block
> > > > > 
> > > > > 
> > > > > Can you wait for a little while before applying this to your
> > > > > for-2.6.28 branch? We need Doug's ACK on this.
> > > > 
> > > > Sure, just let me know...
> > > 
> > > Now we got Doug's ACK on this (Doug, thanks!). Can you apply them to
> > > your for-2.6.28 branch? I'll resend them if necessary.
> > 
> > Yes certainly. No need to resend, I'll add Dougs ack and merge it.
> 
> Actually, the previous was against for-linus (not for-2.6.28), so if you
> could resend against 2.6.28 that would help a lot. Thanks!

Done, though actually the patchset in my git tree was updated against
for-linus.

Thanks,
