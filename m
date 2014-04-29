From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2 00/12] scsi/NCR5380: fix debugging macros and #include
 structure
Date: Tue, 29 Apr 2014 12:22:18 +1000 (EST)
Message-ID: <alpine.LNX.2.00.1404291202190.32739@nippy.intranet>
References: <20140319123516.542623278@telegraphics.com.au> <1398532863.24466.2.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1398532863.24466.2.camel@dabdike.int.hansenpartnership.com>
Sender: linux-m68k-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Sat, 26 Apr 2014, James Bottomley wrote:

> OK, so this is a pretty big change to an unmaintained driver.  I'll take 
> it if you're willing to maintain the driver afterwards ... in which case 
> I need another patch to add you to the MAINTAINERS file.

Sure, I'm happy to support these patches and future work I plan to do on 
the driver.

What additional responsibilities would come with adding my name the 
MAINTAINERS file?

Perhaps Michael and Sam would be interested in sharing the role, for atari 
and sun3 NCR5380 drivers (?)

I only have hardware to test mac_scsi but I can obtain a Domex DMX3191D 
PCI card on ebay.

--
