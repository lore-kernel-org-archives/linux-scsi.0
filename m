From: Andrew Morton <akpm@osdl.org>
Subject: Re: [patch 30/31] scsi: clean up warnings in Advansys driver
Date: Fri, 9 Jun 2006 00:04:29 -0700
Message-ID: <20060609000429.51cf4e46.akpm@osdl.org>
References: <200606090524.k595O5dX032361@shell0.pdx.osdl.net>
	<44891AF5.30406@syncleus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:35720 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751390AbWFIHEh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 03:04:37 -0400
In-Reply-To: <44891AF5.30406@syncleus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeffrey Phillips Freeman <jeffreyfreeman@syncleus.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, ken@krwtech.com

On Fri, 09 Jun 2006 02:53:41 -0400
Jeffrey Phillips Freeman <jeffreyfreeman@syncleus.com> wrote:

> Oh, its great to see my name on the advansys list as a tester. You 
> almost got filed away with the rest of my spam. I would love to test 
> this patch but before i do is there some howto or overview document to 
> help familarize me as a tester. I am comfortable with linuc and the 
> kernel as well as patching. But i wasnt sure if there was a perticular 
> version of the kernal i should try this patch on or a procedure i should 
> follow. Any information that can be provided to go about this properly 
> would be apprecaited. I would love to contribute, and if im going to 
> contribute it should be done right!

Thanks.

Nothing fancy is needed - it would be sufficient to use the most recentl
major release (2.6.15, 2.6.16, 2.6.17, etc) in your daily operations and
report any problems.

I made a note of this in the changelog because with some of these drivers
nobody has the hardware - if someone decided to do some maintenance work on
this driver it could be useful for them to ask you to regression test their
changes.  They'd ask something like "please install 2.6.18-rc2 and let us
know if it breaks".

