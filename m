From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
Date: Tue, 6 Oct 2009 13:56:56 -0700
Message-ID: <20091006135656.ac8bb2e7.rdunlap@xenotime.net>
References: <1254844007.4383.85.camel@mulgrave.site>
	<alpine.LFD.2.01.0910060851590.3432@localhost.localdomain>
	<1254862442.4383.183.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933403AbZJFVFa@vger.kernel.org>
In-Reply-To: <1254862442.4383.183.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 06 Oct 2009 20:54:02 +0000 James Bottomley wrote:

> On Tue, 2009-10-06 at 08:58 -0700, Linus Torvalds wrote:
> > 
> > On Tue, 6 Oct 2009, James Bottomley wrote:
> > >
> > > This is mostly fixes.  However, it contains two new drivers: Brocade SAS
> > > (bfa), the Bladengine2 iSCSI (be2iscsi) under the merge window exemption
> > 
> > Btw, I'm getting less excited about the merge window exemption.
> > 
> > It makes sense for consumer devices that people actually hit and that are 
> > needed for bringup (ie they make a difference between a system that can be 
> > installed and used, and one that cannot), but I'm not at all sure it makes 
> > sense for things like this.
> > 
> > The _reason_ for the driver exemption was the fact that even a broken 
> > driver is better than no driver at all for somebody who just can't get a 
> > working system without it, but that argument really goes away when the 
> > driver is so specialized that it's not about regular hardware any more.
> 
> OK, so I don't see a huge distinction here.  This is a driver for a
> piece of enterprise HW that Linux previously didn't support.  To someone
> cursing not being able to use there hardware, it's every bit as
> important as the latest wireless driver.
> 
> > And the whole "driver exemption" seems to have become a by-word for "I can 
> > ignore the merge window for 50% of my code". Which makes me very tired of 
> > it if there aren't real advantages to real users.
> 
> While the exemption exists, I can certainly ignore the merge window for
> new drivers, yes ... however, that's not 50% of the code submitted in
> the merge window, and it's one time ... the same driver follows the
> merge window for the next release.  I try to police this pretty rigidly
> in SCSI ... as you do at the top.

polices it so rigidly that even simple kernel-doc patches sit in a
scsi git tree for months.  :(


---
~Randy
