From: Matthew Wilcox <willy@debian.org>
Subject: Re: drivers/scsi/Kconfig
Date: Wed, 4 Jun 2003 18:50:20 +0100
Sender: ultralinux-owner@vger.kernel.org
Message-ID: <20030604175020.GI28581@parcelfarce.linux.theplanet.co.uk>
References: <20030530163817.GM28581@parcelfarce.linux.theplanet.co.uk> <20030531043413.D4327@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ultralinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030531043413.D4327@devserv.devel.redhat.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Matthew Wilcox <willy@debian.org>, sparclinux@vger.kernel.org, ultralinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, May 31, 2003 at 04:34:13AM -0400, Pete Zaitcev wrote:
> > Date: 	Fri, 30 May 2003 17:38:17 +0100
> > From: Matthew Wilcox <willy@debian.org>
> 
> > http://ftp.linux.org.uk/pub/linux/willy/patches/scsi-kconfig.diff
> 
> The sparc32 part had a minor problem: deleted "menu" but not "endmenu",
> and so lost the balance. Also, I'd need a better defconfig.

Thanks, fixed:

http://ftp.linux.org.uk/pub/linux/willy/patches/scsi-kconfig-2.diff

I also fixed it in sparc64 where I'd made the same mistake.

I haven't incorporated your defconfig patch in this; most arch defconfigs
are horribly out of date (including x86..) so I'm not trying to maintain
them.  I also made a few more drivers depend on ISA or EISA or PCI for
the benefit of those who don't have them.

> I noticed that killing of a symbios driver was stuffed into
> this patch, I'm wondering if it would be better to separate
> flies and patties, so to speak.

You've been in North Carolina too much ;-)  Removed, but it _is_ going
away.

Comments from m68k or sparc64 people invited ...

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
