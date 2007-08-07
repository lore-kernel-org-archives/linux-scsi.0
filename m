From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Tue, 07 Aug 2007 12:13:36 -0400
Message-ID: <46B89A30.1080404@garzik.org>
References: <1186248703.3439.20.camel@localhost.localdomain>  <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org> <1186458941.6637.44.camel@localhost.localdomain> <alpine.LFD.0.999.0708062059030.5037@woody.linux-foundation.org> <46B86FB5.7020700@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:41887 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbXHGQNl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Aug 2007 12:13:41 -0400
In-Reply-To: <46B86FB5.7020700@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Linus Torvalds <torvalds@linux-foundation.org>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

James Smart wrote:
> However, I take issue with looking at line counts as the sole basis
> for what's appropriate or not. It can be argued that some bug fixes may be
> larger in scope than others, or patch batching so that the bug fix count is
> higher will skew this perception. I also believe that more "lesser" 
> bugfixes
> should be allowed in an earlier -rc? than later, so a hard-and-fast rule 
> for
> line counts seem odd.  Also - what's a bug fix ?  There are many things
> which are not "features" but are necessities for diagnosis or support of 
> the
> larger change. Some of these you simply don't find in time to make sure 
> they
> are in place for the -rc1 merge. Do you hold off on them, or do you make a
> choice based risk/reward based on where the -rc is ? I vote for the latter.
> I realize that the Linux kernel is such a beast overall that you must have
> some simple guidelines, but basing it solely on numbers is a very bad 
> pitfall.


It's straightforward engineering math:  the more LOC that changed, the 
more important it is to /not/ stuff it into a stabilization release, 
because of the greater potential for breaking stuff and negating all the 
existing testing so far.

Once -rc1 is out there, that means the focus should be on stabilizing 
the existing codebase.  Pushing a big driver update means that effort 
must restart from scratch.  We just don't want to go down that road, 
which a big reason for the merge window in general.

If you miss the merge window, tough cookies :)  You gotta deal with it 
just like I do, and everyone else does.

Remember -- the more disciplined we all are with the merge window, the 
more likely it is that a release can be stabilized quickly, and thus, 
the more quickly we will reach the next merge window.

In contrast, increasing violations of the merge window mean increasing 
time between releases.

	Jeff


