From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
Date: Thu, 8 Oct 2009 07:39:34 -0700 (PDT)
Message-ID: <alpine.LFD.2.01.0910080736490.3432@localhost.localdomain>
References: <1254844007.4383.85.camel@mulgrave.site>  <alpine.LFD.2.01.0910060851590.3432@localhost.localdomain>  <1254862442.4383.183.camel@mulgrave.site> <1255012399.4187.24.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932322AbZJHOkS@vger.kernel.org>
In-Reply-To: <1255012399.4187.24.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On Thu, 8 Oct 2009, James Bottomley wrote:
> 
> So what do you want to do about this? 

I'm taking it (and the parisc one I was also unhappy with), but I'm a bit 
grumpy as usual. The parisc pull came totally outside the merge window, 
and the SCSI fix pull is technically perfectly fine, but what makes me 
grumpy is that I get the strong feeling that people aren't even _trying_ 
to hit the merge window with new drivers, because they decide that they 
instead can just push them any time.

So I don't think I necessarily want to change the "new driver" policy per 
se, but I want people to see the merge window as the _primary_ time you 
get any new code in. The "yes, we'll take new drivers" thing should be the 
exception rather than the rule. It doesn't seem to be an exception.

		Linus
