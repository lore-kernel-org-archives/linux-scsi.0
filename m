From: Stefani Seibold <stefani@seibold.net>
Subject: Re: [PATCH] libsrp: fix compile failure
Date: Mon, 04 Jan 2010 20:24:14 +0100
Message-ID: <1262633054.4814.21.camel@wall-e>
References: <1262200866.2749.226.camel@mulgrave.site>
	 <alpine.LFD.2.00.0912301132260.11961@localhost.localdomain>
	 <alpine.LRH.2.00.1001041619130.15694@twin.jikos.cz>
	 <1262625721.2724.158.camel@mulgrave.site>
	 <20100104173530.48690e39@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753790Ab0ADTY1@vger.kernel.org>
In-Reply-To: <20100104173530.48690e39@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@suse.de>, Jiri Kosina <jkosina@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Am Montag, den 04.01.2010, 17:35 +0000 schrieb Alan Cox:
> > least once before it goes to Linus.  There were originally technical
> > reasons why -mm wasn't in ... I just thought they'd been fixed by now.
> 
> No - mm also caused problems with the kfifo merge of a core API change
> that didn't go via -next.
> 
> Alan

I tried my best to port everything to the new kfifo API. But it was not
possible to check it against every architecture. x86 and x86_64 was
compile clean. I think the missing #include was not a big thing.

Stefani
