From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Mon, 6 Aug 2007 21:01:46 -0700 (PDT)
Message-ID: <alpine.LFD.0.999.0708062059030.5037@woody.linux-foundation.org>
References: <1186248703.3439.20.camel@localhost.localdomain>
 <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>
 <1186458941.6637.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52718 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750695AbXHGECX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2007 00:02:23 -0400
In-Reply-To: <1186458941.6637.44.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>



On Mon, 6 Aug 2007, James Bottomley wrote:
>
> Confused ... you did get the first pull request in the first week.

Here's the problem. Let me repeat it again:

> > And after -rc1, I don't want to see crap like this:
> > 
> > 	 46 files changed, 2837 insertions(+), 2050 deletions(-)

It DOES NOT MATTER if I get a first pull request in the first week, if 
that pull request is purely cosmetic, and is followed by stuff that 
*should* have been in the merge window four weeks afterwards.

> OK ... that's arguable.

There's nothing arguable at all about it.

If you have 5000 lines of changes, that's not a "bugfix" any more. That's 
a big damn change, and it should have happened in the merge window. Or if 
it doesn't make it in time, in the *next* merge window.

			Linus
