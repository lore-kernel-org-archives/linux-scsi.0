From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
Date: Thu, 8 Oct 2009 07:54:15 -0700 (PDT)
Message-ID: <alpine.LFD.2.01.0910080742230.3432@localhost.localdomain>
References: <1254844007.4383.85.camel@mulgrave.site>  <alpine.LFD.2.01.0910060851590.3432@localhost.localdomain>  <1254862442.4383.183.camel@mulgrave.site> <1255012399.4187.24.camel@mulgrave.site> <alpine.LFD.2.01.0910080736490.3432@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932460AbZJHOzM@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0910080736490.3432@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On Thu, 8 Oct 2009, Linus Torvalds wrote:
> 
> I'm taking it (and the parisc one I was also unhappy with)

Actually, looking at it again, I'm wavering.

That BFA driver isn't a "driver". It's a huge subsystem of it's own. It's 
almost 50 _thousand_ lines of code for just a single "driver", and for 
rare hardware at that.

Quite frankly, the "bang per line" is almost zero. 

What the ^&@* is wrong with "enterprise SCSI" people? The amount of crazy 
is overwhelming.

So I've pulled it, but I'm still considering just unpulling it. That 
driver is _not_ "just a driver".  It's something more. Something dank and 
smelly, that has grown in dark and forbidding places.

The whole crazy "high end SCSI" industry needs a f*cking exorcism.

Even if I don't unpull, I don't _ever_ want to see a driver like this 
outside the merge window. And dammit, James, you should have realized 
that.

			Linus
