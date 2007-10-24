From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PATCH] final SCSI pieces for the merge window
Date: Wed, 24 Oct 2007 12:09:14 -0700
Message-ID: <20071024120914.180682a6.akpm@linux-foundation.org>
References: <471E6313.1040704@garzik.org>
	<1193174424.3434.3.camel@localhost.localdomain>
	<471E707B.1020505@garzik.org>
	<20071023.153635.21595587.davem@davemloft.net>
	<1193232490.3396.10.camel@localhost.localdomain>
	<alpine.LFD.0.999.0710240818320.30120@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53257 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155AbXJXTJc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 15:09:32 -0400
In-Reply-To: <alpine.LFD.0.999.0710240818320.30120@woody.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, David Miller <davem@davemloft.net>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Wed, 24 Oct 2007 08:35:21 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 24 Oct 2007, James Bottomley wrote:
> > 
> > OK, so it's no secret that I'm the last of the subsystem maintainers
> > whose day job isn't working on the linux kernel.  If you want a full
> > time person, who did you have in mind?
> 
> Quite frankly, at least for me personally, what I would rather have (in 
> general: this is really not at all SCSI-specific in any way, shape, or 
> form, and not directed at James!) is a less rigid maintainership 
> structure.
> 
> Let's face it, we are *all* likely to be overworked at different times, 
> and even when not overworked, it's just the fact that people need to take 
> a breather etc. And there is seldom - if ever - a very strong argument for 
> having one person per subsystem.

Am OK with all of that, but with a rider.  It would make my life even more
miserable if there was a (say) git-scsi-tweedledee and a
git-scsi-tweedledum.  We already have too much out-of-scope code turning up
in the git trees and having two trees explicitly modifying the same
subsystem would hurt.  It's also bad from an engineering POV: there's a
decent chance that when combined, they just won't work.

So Tweedledee and Tweedledum should both commit to the same tree, please.
