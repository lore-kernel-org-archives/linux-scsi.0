From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Mon, 6 Aug 2007 17:51:57 -0700 (PDT)
Message-ID: <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>
References: <1186248703.3439.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49878 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764136AbXHGAwH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Aug 2007 20:52:07 -0400
In-Reply-To: <1186248703.3439.20.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>



On Sat, 4 Aug 2007, James Bottomley wrote:
>
> This is mainly bug fixes ... there's one or two features completions
> that have been delayed pending ack and review to do with bsg (headers
> and passthrough) but these are really required to complete already
> upstream code.

James, this is the last time *ever* I apply patches from you after -rc1.

You used to have serious problems with the merge window, but for a few 
releases you then seemed to "get it" and got on with the program.

But now it's back to "anythign goes", apparently. And I'm going to take a 
hard-line approach with you now. 

For SCSI merges, if I don't get the first pull request in the FIRST week 
of the merge window, don't bother sending one later, unless it's pure 
fixes and regressions.

And after -rc1, I don't want to see crap like this:

	 46 files changed, 2837 insertions(+), 2050 deletions(-)

because that simply is *not* appropriate after -rc1, much less -rc2.

So I pulled, but I wanted to make it very clear that I'm very unhappy with 
you right now, and you're on my shit-list for the next few releases. Get 
the changes in before -rc1, or just *wait*. If they aren't ready before 
the merge window opens, they simply shouldn't be merged at all.

		Linus
