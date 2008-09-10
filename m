From: David Miller <davem@davemloft.net>
Subject: Re: kernel 2.6.26.3 qla2xxx oopsing on Fire 280R
Date: Tue, 09 Sep 2008 17:30:57 -0700 (PDT)
Message-ID: <20080909.173057.110911649.davem@davemloft.net>
References: <20080909.155716.106283970.davem@davemloft.net>
	<20080909.155951.129856467.davem@davemloft.net>
	<20080910000557.GA4478@orion.carnet.hr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36326
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750864AbYIJAbG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Sep 2008 20:31:06 -0400
In-Reply-To: <20080910000557.GA4478@orion.carnet.hr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joy@entuzijast.net
Cc: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org

From: Josip Rodin <joy@entuzijast.net>
Date: Wed, 10 Sep 2008 02:05:57 +0200

> On Tue, Sep 09, 2008 at 03:59:51PM -0700, David Miller wrote:
> > > > Exactly. And this *has* worked, up to now. I would run update-initramfs and
> > > > it would assemble the initial ramdisk and all was well.
> > > 
> > > I wonder if the new firmware code looks for firmware under a different
> > > directory in the initramfs or filesystem, such as /lib/firmware/${KERNEL_VERSION}/
> > > and this is what is burning you.
> > > 
> > > Wish I could be more help, this stuff is just as perplexing to me :-/
> > 
> > I wonder if you have to do some "make firmware_install" or similar now.
> 
> Hm, I tried that, and got a bunch of new files put in /lib/firmware, but
> still none of it seems to be qla2xxx-related, so it doesn't like something
> worth a test (reboot). And it's also not restricted to a version directory,
> so I guess that's not it, either.
> 
> JFTR, here's the list:

Fair enough, I'm stumped :)
