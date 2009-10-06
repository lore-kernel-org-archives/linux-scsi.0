From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
Date: Tue, 06 Oct 2009 20:54:02 +0000
Message-ID: <1254862442.4383.183.camel@mulgrave.site>
References: <1254844007.4383.85.camel@mulgrave.site>
	 <alpine.LFD.2.01.0910060851590.3432@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52999 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933324AbZJFUyr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Oct 2009 16:54:47 -0400
In-Reply-To: <alpine.LFD.2.01.0910060851590.3432@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, 2009-10-06 at 08:58 -0700, Linus Torvalds wrote:
> 
> On Tue, 6 Oct 2009, James Bottomley wrote:
> >
> > This is mostly fixes.  However, it contains two new drivers: Brocade SAS
> > (bfa), the Bladengine2 iSCSI (be2iscsi) under the merge window exemption
> 
> Btw, I'm getting less excited about the merge window exemption.
> 
> It makes sense for consumer devices that people actually hit and that are 
> needed for bringup (ie they make a difference between a system that can be 
> installed and used, and one that cannot), but I'm not at all sure it makes 
> sense for things like this.
> 
> The _reason_ for the driver exemption was the fact that even a broken 
> driver is better than no driver at all for somebody who just can't get a 
> working system without it, but that argument really goes away when the 
> driver is so specialized that it's not about regular hardware any more.

OK, so I don't see a huge distinction here.  This is a driver for a
piece of enterprise HW that Linux previously didn't support.  To someone
cursing not being able to use there hardware, it's every bit as
important as the latest wireless driver.

> And the whole "driver exemption" seems to have become a by-word for "I can 
> ignore the merge window for 50% of my code". Which makes me very tired of 
> it if there aren't real advantages to real users.

While the exemption exists, I can certainly ignore the merge window for
new drivers, yes ... however, that's not 50% of the code submitted in
the merge window, and it's one time ... the same driver follows the
merge window for the next release.  I try to police this pretty rigidly
in SCSI ... as you do at the top.

In fact, for SCSI, these two drivers are the third and fourth merge
window exemptions in our year long history of allowing this.

> So I'm seriously considering a "the driver has to be mass market and also 
> actually matter to an install" rule for the exemption to be valid.

OK, so on the policy, let me argue against the above.  One of the things
we've been saying about linux is that we facilitate rapid adoption of
new hardware (and that we support more hardware than any other OS).  The
Merge window exemption was adopted at the kernel summit last year
specifically to speed our adoption of new hardware.  I think it's
valuable for this speed of adoption to be *all* hardware, not
specifically mass market laptop type stuff.

However, even if you want to change the definition, can we please not do
it retroactively?

Thanks,

James


