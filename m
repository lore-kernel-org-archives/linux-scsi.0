From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 7/8] be2iscsi: Fix processing cqe for cxn whose endpoint
 is freed
Date: Mon, 2 Jun 2014 12:33:49 -0700
Message-ID: <20140602193349.GA11555@infradead.org>
References: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
 <1399340492-2136-7-git-send-email-jkallickal@emulex.com>
 <536AB13E.6080906@cs.wisc.edu>
 <0eb11761-3b46-44d0-b35a-16d121fe1df4@CMEXHTCAS2.ad.emulex.com>
 <20140602064601.GA6630@infradead.org>
 <1401736926.12939.13.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:32780 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaFBTdz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 15:33:55 -0400
Content-Disposition: inline
In-Reply-To: <1401736926.12939.13.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "MinhDuc.Tran@Emulex.Com" <MinhDuc.Tran@Emulex.Com>, "jayamohank@gmail.com" <jayamohank@gmail.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Sony.John-N@Emulex.Com" <Sony.John-N@Emulex.Com>, "Jayamohan.Kallickal@Emulex.Com" <Jayamohan.Kallickal@Emulex.Com>

On Mon, Jun 02, 2014 at 07:22:07PM +0000, James Bottomley wrote:
> Actually, can you really pull it out, not just revert it?  Reverts cause
> problems with bisection and are unnecessary before the tree goes to
> Linus.
> 
> If preserving history becomes a real goal, we'd have to move to a tip
> like model, but I'm happy coping with the rebase that dropping a patch
> from a monolithic tree causes.

Linus has been very unappy about rebasing close to or in the merge
window, and other subsystems generally revert patches that late in the
cycle as well.  I'd prefer to stick to that model, but if you and Linus
prefer the rebase now I can do it as well of course.
