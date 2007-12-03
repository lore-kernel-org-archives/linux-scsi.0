From: Krzysztof =?utf-8?q?B=C5=82aszkowski?= <kb@sysmikro.com.pl>
Subject: Re: aic94xx or libsas crash on X7DB3 supermicro with enclosure and sata drives
Date: Mon, 3 Dec 2007 21:06:44 +0100
Message-ID: <200712032106.44176.kb@sysmikro.com.pl>
References: <200711301022.08001.kb@sysmikro.com.pl> <200712031709.54168.kb@sysmikro.com.pl> <20071203193652.GB7066@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from v007470.home.net.pl ([212.85.125.104]:50803 "HELO
	v007470.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752279AbXLCUHA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Dec 2007 15:07:00 -0500
In-Reply-To: <20071203193652.GB7066@tree.beaverton.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, vst@vlnb.net, Alexis Bruemmer <alexisb@us.ibm.com>

Hi Darrick,

On Monday 03 December 2007 20:36, Darrick J. Wong wrote:
> On Mon, Dec 03, 2007 at 05:09:54PM +0100, Krzysztof B??aszkowski wrote:
> > I noticed also another failure when i removed a drive. The event was not
> > notified by anything (ie the block device and corresponding sg were
> > registered) so i run dd on this truly "virtual" drive.
> >
> > dd reached D state (as well as scsi_wq) . i think it shouldn't happen no
> > matter it was AIC failure or LSI expander failure.
>
> "It's wireless!" ;)

yep :) and energy from positive thinking spins disk's plates ;) 

>
> Seriously, though, it's a good idea to tell the kernel that you're
> about to unplug a disk before actually doing it:
>
> echo 1 > /sys/block/sdX/device/delete
>
> This way, the kernel can tell the disk to flush its caches long before
> power actually gets removed.  Otherwise, the device removal code can
> get hung up just like you observed, and whatever's in the write cache
> may or may not actually get written to the media.
>

imagine just raining Monday and someone who put hand on the drive thus he had 
to reboot whole box.

Thanks,
Krzysztof
> --D
