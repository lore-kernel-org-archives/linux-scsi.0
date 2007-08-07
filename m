From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Tue, 07 Aug 2007 10:56:54 -0400
Message-ID: <46B88836.5020604@garzik.org>
References: <1186248703.3439.20.camel@localhost.localdomain>	<alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>	<1186458941.6637.44.camel@localhost.localdomain>	<20070807001429.f8cb3b22.akpm@linux-foundation.org>	<1186496712.3414.17.camel@localhost.localdomain> <20070807155521.0dc9f068@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:39352 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934780AbXHGO45 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Aug 2007 10:56:57 -0400
In-Reply-To: <20070807155521.0dc9f068@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Alan Cox wrote:
>> I fully agree, and firmly believe that the current stabilisation works
>> incredibly well for shaking out bugs.  My problem is that it doesn't
>> work for stabilising features.  Either we have to get far more people
>> doing feature integration testing before the merge window, or we have to
>> accept feature updates after the merge window (for existing features
>> that are having stability issues).
> 
> The other alternative is that if Linus won't take updates you ask him to
> revert bsg so that you don't get a half baked merge as a result of this.
> I'm not sure that is a good path to follow either however.

Like everything else in life, it's a balance.  If something is clearly 
half-baked and requires a bunch of post-rc1 changes just to be usable, a 
revert might make a lot of sense.

It's questions of: how much further change is required, how invasive are 
those changes, how half-baked and incomplete is the feature really, what 
is the downside of a revert, ...

	Jeff



