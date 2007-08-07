From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Tue, 07 Aug 2007 09:12:21 -0400
Message-ID: <46B86FB5.7020700@emulex.com>
References: <1186248703.3439.20.camel@localhost.localdomain>  <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org> <1186458941.6637.44.camel@localhost.localdomain> <alpine.LFD.0.999.0708062059030.5037@woody.linux-foundation.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:49294 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759532AbXHGNMh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2007 09:12:37 -0400
In-Reply-To: <alpine.LFD.0.999.0708062059030.5037@woody.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

In defense of my maintainer, who was working on my behalf! ...

The lpfc mods were the bulk of the +/- counts.  We batch our bug fixes
together and then push to James as a large lump. Unfortunately, we had
a change that changed logging from a base object to a subobject. Although
not risky, it did account for a lot of +/- changes.  The way we pushed
to James, did not allow for him to easily segment one set of changes
from the other. Emulex will change this behavior, hopefully making this
easier on James to keep you happy.

However, I take issue with looking at line counts as the sole basis
for what's appropriate or not. It can be argued that some bug fixes may be
larger in scope than others, or patch batching so that the bug fix count is
higher will skew this perception. I also believe that more "lesser" bugfixes
should be allowed in an earlier -rc? than later, so a hard-and-fast rule for
line counts seem odd.  Also - what's a bug fix ?  There are many things
which are not "features" but are necessities for diagnosis or support of the
larger change. Some of these you simply don't find in time to make sure they
are in place for the -rc1 merge. Do you hold off on them, or do you make a
choice based risk/reward based on where the -rc is ? I vote for the latter.
I realize that the Linux kernel is such a beast overall that you must have
some simple guidelines, but basing it solely on numbers is a very bad pitfall.

-- james s


Linus Torvalds wrote:
> 
> On Mon, 6 Aug 2007, James Bottomley wrote:
>> Confused ... you did get the first pull request in the first week.
> 
> Here's the problem. Let me repeat it again:
> 
>>> And after -rc1, I don't want to see crap like this:
>>>
>>> 	 46 files changed, 2837 insertions(+), 2050 deletions(-)
> 
> It DOES NOT MATTER if I get a first pull request in the first week, if 
> that pull request is purely cosmetic, and is followed by stuff that 
> *should* have been in the merge window four weeks afterwards.
> 
>> OK ... that's arguable.
> 
> There's nothing arguable at all about it.
> 
> If you have 5000 lines of changes, that's not a "bugfix" any more. That's 
> a big damn change, and it should have happened in the merge window. Or if 
> it doesn't make it in time, in the *next* merge window.
> 
> 			Linus
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
