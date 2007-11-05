From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git patches] Add and use media change notification
Date: Sun, 4 Nov 2007 18:00:15 -0800 (PST)
Message-ID: <alpine.LFD.0.999.0711041755120.15101@woody.linux-foundation.org>
References: <20071104150711.GA29087@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50430 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753139AbXKECA0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Nov 2007 21:00:26 -0500
In-Reply-To: <20071104150711.GA29087@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org



On Sun, 4 Nov 2007, Jeff Garzik wrote:
> 
> The end to CD-ROM polling...  newer SATA ATAPI hardware will emit
> 'asynchronous notification' events when media is changed.  This adds
> support.

I *really* didn't want to pull this.

Not only is it after the -rc1 period, but I also think you pushed this ina 
really offensive manner, and I don't like how you and James have made this 
whole thing personal. You guys need to sort it out, and there is no way 
you can blame James for all your troubles, since I've heard the same kind 
of complaints about every single maintainer out there (including you) 
about some driver or other infrastructure issue.

So I'm unhappy about pulling this.

That said, I did finally decide to just pull it. Partly because the 
concept apparently has been in -mm for a while anyway (even if the final 
patch has not - but the patch itself isn't that large, I'd worry more 
about thngs like certain hardware simply not doing things right), but 
mostly because I hate it when others hold up driver features, and I 
decided that in this case this really is something that is better done 
earlier rather than later, to get exposure as soon as possible.

But I really think you need to lay off James, and help him rather than 
make every single complaint a big flame-war!

Please, Jeff?

		Linus
