From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Tue, 07 Aug 2007 12:06:49 -0400
Message-ID: <46B89899.5020303@garzik.org>
References: <1186248703.3439.20.camel@localhost.localdomain>	 <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org> <1186458941.6637.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:41433 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbXHGQGv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Aug 2007 12:06:51 -0400
In-Reply-To: <1186458941.6637.44.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

James Bottomley wrote:
> OK ... that's arguable.  This one is larger than I like because of the
> lpfc bug fix patch ... I accept I need to do a better job getting these
> into the merge window via the scsi-misc tree.  So I will accept the "too
> big" criticism and try to manage the driver maintainers better.
> 
> However, I won't accept the "not bug fixes only" criticism at -rc1.  The
> problem is that we're trying to stabilise a new feature: bsg.

Just so we don't lose the forest for the trees...

Not trying to put words in Linus's mouth, but it seems to me he wasn't 
complaining specifically about bsg.  "style cleanups", "cosmetic 
cleanups", ancient ISA driver polishing (1542, my gdth patch) are 
definitely not "bug fix only" material.

The lpfc update was probably the biggest thing, LOC-wise.  And even 
though that was mostly bug fixes -- and notably NOT 100% fixes -- it is 
big enough to warrant integration testing and exposure prior to 
mainline.  Definitely merge-window-open material AFAICS.

	Jeff


