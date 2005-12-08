From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: linux kernel panic when ejecting ieee1394 ipod
Date: Thu, 08 Dec 2005 02:17:35 +0100
Message-ID: <439789AF.4070500@s5r6.in-berlin.de>
References: <200512072358.15398.adq_dvb@lidskialf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:1743 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932157AbVLHBTo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Dec 2005 20:19:44 -0500
In-Reply-To: <200512072358.15398.adq_dvb@lidskialf.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew de Quincey <adq_dvb@lidskialf.net>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Andrew de Quincey wrote to linux1394-devel:
> Reposting to the -devel list since there was no response on -user.

I would have responded eventually... :-)

> Hi, I'm using linux kernel 2.6.14 with an generation 1 ipod connected via 
> ieee1394/sbp2.
> 
> I can mount/unmount it and use it fine. It even works with HAL now.
> 
> The problem comes when I want to remove it. If I do:
> 
> eject /dev/sdb
> 
> The kernel panics with the following error:
> Kernel panic - not syncing: PCI-DMA: high address but no IOMMU

I think there was another report about "eject" of a FireWire iPod 
crashing the kernel but I cannot find it in any archive anymore and do 
not remember which kernel version and machine architecture was affected.

The eject command does work for me with a few different SBP-2 devices, 
but I do not have an iPod. But more importantly, I have currently only 
i386 with 512 MB RAM to test. The "high address but no IOMMU" panic 
message is specific to x86_64.

I had only a superficial look at it so far and did not spot anything 
obvious. (That's because I do not know anything about Linux' memory 
management.) My only idea at the moment is to Cc this to linux-scsi 
since sd_mod does work for you but the one thing you do via the sg 
driver does not.

> I'm using an nforce 4 motherboard (Asus A8N-SLI Deluxe). The ipod is attached 
> to the ieee1394 port on a creative labs Audigy2 sound card (uses OHCI-1394).
> 
> I do _not_ have "Enable Phys DMA support for SBP2 (Debug)" enabled if thats 
> any help.

-- 
Stefan Richter
-=====-=-=-= ==-- -=---
http://arcgraph.de/sr/
