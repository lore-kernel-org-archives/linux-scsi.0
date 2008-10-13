From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] intermediate SCSI updates
Date: Mon, 13 Oct 2008 14:22:13 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0810131416410.3288@nehalem.linux-foundation.org>
References: <1223909115.5566.13.camel@localhost.localdomain>  <alpine.LFD.2.00.0810131017030.3288@nehalem.linux-foundation.org> <1223925606.5566.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759670AbYJMVWr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Oct 2008 17:22:47 -0400
In-Reply-To: <1223925606.5566.20.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>



On Mon, 13 Oct 2008, James Bottomley wrote:
> 
> Not exactly.  It has to be rebased to run as a postmerge tree, but it
> does get tested by me (admittedly on my limited set of machines, which
> don't include any actual devices that do block integrity) every time I
> rebase.

What I'm upset about is that this has apparently gotten not even some 
trivial testing of the _default_ build. I'm not talking about any odd 
config options here. I'm literally talking about the only _sane_ config 
option case.

You yourself admit that even you don't have any actual devices that can 
support the block integrity stuff, yet you have apparently only compile- 
tested the insane case of still enabling that thing and apparently nobody 
else has bothered either.

Was this in linux-next?

Is linux-next coverage REALLY so weak that it doesn't even test the 
default config options, much less any random options? What's the point of 
linux-next then?

Again, the date on that thing is claimed to be September 19th, although it 
was obviously committed later.

> However, does this work for you?  It fixes the problem for me.

I could trivially have fixed the compile issue. That's not what upsets me. 
What upsets me is that this set of patches apparently had almost nobody 
looking at them at all before they got sent to me.

If it was some odd and unusual config option, I'd be less upset. hey, 
stuff happens. But it sure as heck was nothing of the sort!

			Linus
