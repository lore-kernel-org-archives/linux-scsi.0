From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Tue, 07 Aug 2007 11:31:11 -0500
Message-ID: <1186504271.3414.34.camel@localhost.localdomain>
References: <1186248703.3439.20.camel@localhost.localdomain>
	 <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>
	 <1186458941.6637.44.camel@localhost.localdomain>
	 <alpine.LFD.0.999.0708062059030.5037@woody.linux-foundation.org>
	 <1186497106.3414.24.camel@localhost.localdomain>
	 <46B89BE7.8090903@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44395 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751598AbXHGQbM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2007 12:31:12 -0400
In-Reply-To: <46B89BE7.8090903@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, 2007-08-07 at 12:20 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > I'm arguing that a too strict an interpretation of bugfix only post -rc1
> > will damage feature stabilisation.  Please think carefully about this.
> > If we go out in a released kernel with a problematic user space ABI, we
> > end up being committed to it forever.
> 
> 
> IMO you're going off on your own tangent.  Linus never singled out bsg 
> (far from it, in fact, since bsg was not a major LOC contributor) or 
> declared ABI-related fixes verboten.
> 
> I don't think anyone wants to release a userspace ABI with problems, 
> since we all know that's basically locked in stone once its in a 
> mainline release.
> 
> AFAICS his main complaint was he felt your push was a big honking huge 
> change, late in the game, that included obvious non-fixes.  And it was. 
>   lpfc was probably the biggest part of that, not bsg, and it's pretty 
> clear such a big lpfc update should have gone in when the merge window 
> was open.  The [non-lpfc] cleanups were also not -rc2 material.

I think you'll find that part of the complaint was addressed in the
first part of the email which you didn't quote.

James


