From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Tue, 07 Aug 2007 12:34:54 -0400
Message-ID: <46B89F2E.10405@garzik.org>
References: <1186248703.3439.20.camel@localhost.localdomain>	 <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org> <1186458941.6637.44.camel@localhost.localdomain> <46B89899.5020303@garzik.org> <46B89D77.9000506@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:32978 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbXHGQe6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Aug 2007 12:34:58 -0400
In-Reply-To: <46B89D77.9000506@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

James Smart wrote:
> Jeff Garzik wrote:
>> The lpfc update was probably the biggest thing, LOC-wise.  And even 
>> though that was mostly bug fixes -- and notably NOT 100% fixes -- it 
>> is big enough to warrant integration testing and exposure prior to 
>> mainline.  Definitely merge-window-open material AFAICS.
> 
> FYI - it is integrated and tested prior to mainline, by Emulex (and who
> else *really* tests it close to the degree we do ?). We do so, as a whole,
> weeks ahead of the submit to the maintainer. Usually, there's only a couple
> of small api changes that are picked up when we merge into the maintainers
> pool.  And most of these are caught by us prior anyway as we package the
> patchsets and ensure the integration into the maintainers pool is smooth.

This is a highly common pattern, and unfortunately you get the highly 
common Linux response:

In Linux we never ever assume a driver is working simply because the 
hardware vendor tested it.  A decade of real world experience PROVES 
precisely the opposite -- getting code out into the world early and 
often repeatedly turned up problems not seen in hardware vendor's testing.

Take a lesson from when I was on Linus's shit-list... twice:  Twice, 
Intel submitted an e1000 update after the merge window closed.  Twice, 
they claimed the driver passed their quite-exhaustive internal testing. 
  And twice, the most popular network driver broke for large masses of 
users because I took a hardware vendor's word on testing rather than 
rely on the testing PROVEN to flush out problems:  public linux kernel 
testing.

I'm not singling out Intel, there are plenty of other hardware vendors 
that repeat the exact same pattern.

It's quite simply impossible for a hardware vendor to test all the weird 
combinations in the field.  Our test lab -- the Internet -- is the one 
we trust.

	Jeff


