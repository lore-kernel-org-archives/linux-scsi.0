From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.25
Date: Sun, 20 Apr 2008 13:56:30 -0600
Message-ID: <20080420195630.GS20637@parisc-linux.org>
References: <1208540517.3063.18.camel@localhost.localdomain> <20080419151934.GA17089@elte.hu> <1208620484.3280.23.camel@localhost.localdomain> <20080419170530.GD1595@cs181133002.pp.htv.fi> <1208626496.3280.40.camel@localhost.localdomain> <alpine.LFD.1.10.0804191305360.2779@woody.linux-foundation.org> <20080419204511.GP20637@parisc-linux.org> <480B4E97.9030805@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43999 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbYDTT4r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Apr 2008 15:56:47 -0400
Content-Disposition: inline
In-Reply-To: <480B4E97.9030805@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>

On Sun, Apr 20, 2008 at 04:09:27PM +0200, Stefan Richter wrote:
> Matthew Wilcox wrote:
> >--- a/Documentation/kbuild/kconfig-language.txt
> >+++ b/Documentation/kbuild/kconfig-language.txt
> >   Note:
> >-	select is evil.... select will by brute force set a symbol
> >-	equal to 'y' without visiting the dependencies. So abusing
> >-	select you are able to select a symbol FOO even if FOO depends
> >+	select should be used with care.  It can set a symbol
> >+	without visiting the dependencies.  By abusing select you are
> >+	able to select a symbol FOO even if FOO depends
> > 	on BAR that is not set. In general use select only for
> > 	non-visible symbols (no prompts anywhere) and for symbols with
> > 	no dependencies. That will limit the usefulness but on the
> 
> "It can set a symbol without visiting the dependencies." = imprecise
> 
> "select will by brute force set a symbol [...] without visiting the 
> dependencies." = clear.  So why not leave this portion of the text as it is.

"brute force" is pejorative, not clear.  I'm not really interested in
bikeshedding this issue.

> Maybe change
> 	"equal to 'y'"
> to
> 	"equal to 'y' or 'm'"
> or to
> 	""
> to make it entirely correct.
> -- 
> Stefan Richter
> -=====-==--- -=-- =-=--
> http://arcgraph.de/sr/

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
