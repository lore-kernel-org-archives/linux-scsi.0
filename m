From: christophe.varoqui@free.fr
Subject: Re: storageworks controlers & linux-scsi
Date: Fri, 29 Aug 2003 12:25:46 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1062152746.3f4f2a2ab5f3e@impt1-2.free.fr>
References: <1061816116.3f4a073487d64@impt3-1.free.fr> <1061999793.1660.8.camel@mulgrave> <20030828013706.45760cb5.christophe.varoqui@free.fr> <20030828130626.A15749@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-2.free.fr ([213.228.0.176]:32465 "EHLO
	postfix4-2.free.fr") by vger.kernel.org with ESMTP id S264500AbTH2KZw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Aug 2003 06:25:52 -0400
In-Reply-To: <20030828130626.A15749@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Selon Patrick Mansfield <patmans@us.ibm.com>:

> On Thu, Aug 28, 2003 at 01:37:06AM +0200, christophe varoqui wrote:
> > 
> > I leave for a 2 week vacation, but if the HSV LUNs handling is turned to a
> usable state I'll be able to post a GPL C agent to handle DM multipath
> autoconfig & reconfig on event (through VPD 0x83 for wwid detection and TUR
> for ghosts detection) in  about 3 weeks. In hope there will interest to move
> it to a broader use.
> > 
> 
> Hi -
> 
> Is that a 2.4 solution?
it initialy is.
2.6 support will be easy to add, as we don't have to mess with /dev/sg* anymore.

> 
> I was starting to work on a hotplug interface to get and store scsi wwid's
> or serial numbers for use with 2.6.
> 
good

> We need a method that would (ideally) work for all users, so we: don't
> hang broken devices, can use other pages (0x80), can use vendor
> specific methods, and works for udev or multipath config tools.
> 
> We need a black/white list (or config file) for the broken or special
> devices.
>
Speaking of blacklists, the kernel lists could be fed in early userspace and 
thus tweaked at run-time. Didn't Linus search for initramfs uses ? :)

While I'm in the wish list, it would be good to 
have 'cat /sys/bus/scsi/...../tur' trigger a TUR and echo the result.

> Have you seen the libsysfs/udev code? We can use libsysfs for common
> interfaces to get/set a scsi serial number, and for other common uses of
> sysfs such as getting the bus_id, or figuring out if we have a scsi
> device.
> 
yes, will do. Thanks for the feedback and hints

regards,
cvaroqui
