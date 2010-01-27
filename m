From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.33-rc5
Date: Wed, 27 Jan 2010 16:33:29 -0600
Message-ID: <1264631609.3075.94.camel@mulgrave.site>
References: <1264614691.3075.19.camel@mulgrave.site>
	 <20100127222404.6dfdd0a7@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756355Ab0A0Wdg@vger.kernel.org>
In-Reply-To: <20100127222404.6dfdd0a7@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-01-27 at 22:24 +0000, Alan Cox wrote:
> > Penchala Narasimha Reddy Chilakala, ERS-HCLTech (1):
> >       aacraid: fix File System going into read-only mode
> 
> If aacraid is actually getting patches then see
> also http://bugzilla.kernel.org/show_bug.cgi?id=11120 which I found
> bugzilla tidyying.
> 
> Contains a patch and test confirmations

So the patch it contains is almost certainly wrong in general; Mark was
just suggesting it as a trial ... it might work for specific adapter
versions but reducing the queue depth by half globally will impact
performance noticeably.  The bug report does rather sound like cabling
issues are leading to a firmware related problem.

James
