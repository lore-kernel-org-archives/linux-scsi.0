From: David Miller <davem@davemloft.net>
Subject: Re: kernel 2.6.26.3 qla2xxx oopsing on Fire 280R
Date: Tue, 09 Sep 2008 15:57:16 -0700 (PDT)
Message-ID: <20080909.155716.106283970.davem@davemloft.net>
References: <20080909150023.GA31517@orion.carnet.hr>
	<20080909.143012.193704777.davem@davemloft.net>
	<20080909220038.GA13300@orion.carnet.hr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20080909220038.GA13300@orion.carnet.hr>
Sender: sparclinux-owner@vger.kernel.org
To: joy@entuzijast.net
Cc: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Josip Rodin <joy@entuzijast.net>
Date: Wed, 10 Sep 2008 00:00:38 +0200

> On Tue, Sep 09, 2008 at 02:30:12PM -0700, David Miller wrote:
> > I assume you use this device for your too filesystem, in which case
> > the firmware has to be in the initial ramdisk.
> > 
> > The qla2xxx firmware isn't in the firmware tree, it's in the filesystem
> > somewhere, and that gets put into the initial ramdisk you build for
> > a particular kernel image.  For this reason CONFIG_FIRMWARE_IN_KERNEL
> > won't make any difference.
> > 
> > This takes a bit of skill to get working properly, I hate it too.  It's
> > really unfriendly to users and even kernel developers.  These drivers
> > should "just work" when you build them, rather than require contortions
> > such as this.
> 
> Exactly. And this *has* worked, up to now. I would run update-initramfs and
> it would assemble the initial ramdisk and all was well.

I wonder if the new firmware code looks for firmware under a different
directory in the initramfs or filesystem, such as /lib/firmware/${KERNEL_VERSION}/
and this is what is burning you.

Wish I could be more help, this stuff is just as perplexing to me :-/
