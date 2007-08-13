From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Mon, 13 Aug 2007 11:58:38 -0400
Message-ID: <46C07FAE.1040504@garzik.org>
References: <1186248703.3439.20.camel@localhost.localdomain> <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org> <1186458941.6637.44.camel@localhost.localdomain> <20070807001429.f8cb3b22.akpm@linux-foundation.org> <1186496712.3414.17.camel@localhost.localdomain> <46B88B91.4050703@garzik.org> <1186501124.3414.32.camel@localhost.localdomain> <20070807105144.0ba67d81.akpm@linux-foundation.org> <20070813124225.GT23758@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58169 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S971344AbXHMP6u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 11:58:50 -0400
In-Reply-To: <20070813124225.GT23758@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Jens Axboe wrote:
> #for-akpm is usually only in very few -mm release anyway, so it's not
> like it would have made much difference. We/you/I need to improve that,
> certainly.
> 
> Honestly, for bsg, it wasn't much of an issue. We had build problems
> when bsg was merged which was unfortunate but got fixed quickly. Having
> bsg in -mm would not have caused any testing of the driver in question
> outside of what it already received, given the nature of it.


That's just an excuse for what happened -- you made an end run around 
our test tree.  Pretty please with sugar on it -- make sure changes show 
up in -mm.

	Jeff


