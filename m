From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [BUG 2.6.17-git] kmem_cache_create: duplicate cache scsi_cmd_cache
Date: Fri, 12 May 2006 14:46:10 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0605121439070.3866@g5.osdl.org>
References: <20060511151456.GD3755@harddisk-recovery.com>
 <15ddcffd0605112153q57f139a1k7068e204a3eeaf1f@mail.gmail.com>
 <20060512171632.GA29077@harddisk-recovery.com> <Pine.LNX.4.64.0605121024310.3866@g5.osdl.org>
 <1147456038.3769.39.camel@mulgrave.il.steeleye.com>
 <1147460325.3769.46.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0605121209020.3866@g5.osdl.org> <20060512203850.GC17120@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0605121346060.3866@g5.osdl.org> <20060512205804.GD17120@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0605121409250.3866@g5.osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:1224 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932169AbWELVqk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 17:46:40 -0400
In-Reply-To: <Pine.LNX.4.64.0605121409250.3866@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Erik Mouw <erik@harddisk-recovery.com>, Or Gerlitz <or.gerlitz@gmail.com>, linux-scsi@vger.kernel.org, axboe@suse.de, Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>



On Fri, 12 May 2006, Linus Torvalds wrote:
> 
> You introduced a commit that fixed one thing, and broke another thing.

And btw, don't take that "you" personally. 

This happens.

All the time. And definitely _not_ just to you. 

It's why common infrastructure can be such an incredible pain: it may be a 
nice common layer, but it does obviously end up affecting a hell of a lot 
of different devices and usages. "Private" code is often much better, and 
that's what we used to have.

Now, sadly, I think we need that common device layer infrastructure 
exactly because otherwise we could never have done any global device 
management etc, so in this case that common interface is definitely a 
"necessary evil". 

And with that necessary evil comes the linkages that it implies. 

We'd all be much happier of one piece of code didn't depend on five or six 
other pieces of code, and a bug-fix in one place would be guaranteed to 
not ever have any other side effects.

We'd all also be much happier if we were all young, healthy, good-looking 
and drive Lamborghinis. And didn't have incipient beer-bellies (not that 
_I_ would ever have one, of course.. Oh, no. I'm obviously talking about 
all you other scruffy people. Me, I'm perfect.)

Sadly, neither of the above schenarios are really very realistic.

So we'd love to have more information. Please?

		Linus
