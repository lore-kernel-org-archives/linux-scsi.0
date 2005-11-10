From: thomas schorpp <t.schorpp@gmx.de>
Subject: (SAT) libata + hdparm/smartctl
Date: Thu, 10 Nov 2005 16:05:51 +0100
Message-ID: <437361CF.2040909@gmx.de>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF4A@WDSCEXBECL03.sc.wdc.com>	 <4371BB82.3090208@gmx.de> <4371C557.80807@gmx.de> <4371F7C3.5080702@rtr.ca>	 <43720232.6090609@gmx.de> <4372172A.50003@gmx.de>	 <43721C3C.1010103@pobox.com> <1131553363.3271.1.camel@mulgrave> <4372E66F.5070802@gmx.de> <437358EA.3090406@rtr.ca>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:32922 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1750711AbVKJPGn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Nov 2005 10:06:43 -0500
In-Reply-To: <437358EA.3090406@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: linux-ide@vger.kernel.org

Mark Lord wrote:
> thomas schorpp wrote:
> 
>>
>> for hdparm ata-security theres ide taskfile used, can scsi command
>> sequences combined with ide taskfiles which use own ioctls?
> 
> 
> As Jeff said, libata translates some of the HDIO_TASK* functions
> into SCSI passthru commands, which then get translated back
> into ATA commands at the time of issue to the device.
> 
> Once passthru makes it out into the wild (Linus kernels),
> I'll update hdparm to have it use SCSI passthru instead
> when available/appropriate.
> 
> There will have to be about a year or so of full overlap
> (hdparm, smartmontools, and kernel), to give distros time
> to update/release with all of the affected components.
> 
> After that, I imagine Jeff may want to remove the HDIO_TASK*
> calls again.
> 
> Cheers

ive tried the whole day to make this driver helper libata or parts of it available to the user space
and it didnt work out, sorry, you cant include the header in user-space apps and theres no interface to it.

but if You say so, i'll take a closer look at libatas HDIO_TASKs but this has to be utilized automatic then,
at this time libata.ko does not get loaded or used by usbstorage devices.

when it is a driver library i will use it with drivers, as it should be:

so i look if i can modify sg, sd_mod or/and usb-storage to detect passthru needing devices automatic and to
take action on passthru needing functionality, then none of the user space apps should need to be worked on.

(hopefully) 

y
tom
