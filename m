From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 7/8] be2iscsi: Fix processing cqe for cxn whose endpoint
 is freed
Date: Mon, 2 Jun 2014 20:02:25 +0000
Message-ID: <1401739344.12939.38.camel@dabdike.int.hansenpartnership.com>
References: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
	 <1399340492-2136-7-git-send-email-jkallickal@emulex.com>
	 <536AB13E.6080906@cs.wisc.edu>
	 <0eb11761-3b46-44d0-b35a-16d121fe1df4@CMEXHTCAS2.ad.emulex.com>
	 <20140602064601.GA6630@infradead.org>
	 <1401736926.12939.13.camel@dabdike.int.hansenpartnership.com>
	 <20140602193349.GA11555@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:32824 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbaFBUC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 16:02:28 -0400
In-Reply-To: <20140602193349.GA11555@infradead.org>
Content-Language: en-US
Content-ID: <C18271D2CFE695448BB3E1758566258B@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jayamohank@gmail.com" <jayamohank@gmail.com>, "MinhDuc.Tran@Emulex.Com" <MinhDuc.Tran@Emulex.Com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Sony.John-N@Emulex.Com" <Sony.John-N@Emulex.Com>, "Jayamohan.Kallickal@Emulex.Com" <Jayamohan.Kallickal@Emulex.Com>

On Mon, 2014-06-02 at 12:33 -0700, hch@infradead.org wrote:
> On Mon, Jun 02, 2014 at 07:22:07PM +0000, James Bottomley wrote:
> > Actually, can you really pull it out, not just revert it?  Reverts cause
> > problems with bisection and are unnecessary before the tree goes to
> > Linus.
> > 
> > If preserving history becomes a real goal, we'd have to move to a tip
> > like model, but I'm happy coping with the rebase that dropping a patch
> > from a monolithic tree causes.
> 
> Linus has been very unappy about rebasing close to or in the merge
> window, and other subsystems generally revert patches that late in the
> cycle as well.  I'd prefer to stick to that model, but if you and Linus
> prefer the rebase now I can do it as well of course.

Yes, please. I've done it before, but note what happened in the pull
message.  He doesn't usually object to this in SCSI because no-one
really develops based on our tree.  As I said, if they did, we'd need to
follow a tip model, so we could just drop the problem driver and redo
the patches.  I also tend to delay the pull a day or so to give
linux-next time to pick up the change, so that Stephen Rothwell doesn't
complain about it.

Thanks,

James

