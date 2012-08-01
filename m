From: Erich Weiler <weiler@soe.ucsc.edu>
Subject: Re: SCSI disk IO problem with JBOD
Date: Tue, 31 Jul 2012 22:31:24 -0700
Message-ID: <5018BF2C.1050608@soe.ucsc.edu>
References: <5018A9EF.2080003@soe.ucsc.edu> <5018BA91.3000506@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63102 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2HAFb1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2012 01:31:27 -0400
Received: by pbbrp8 with SMTP id rp8so512214pbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2012 22:31:27 -0700 (PDT)
In-Reply-To: <5018BA91.3000506@hardwarefreak.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-scsi@vger.kernel.org

Hi Stan,

Thanks for replying!

>> We have a Dell R610 server running CentOS 6.3 (kernel
>> 2.6.32-279.2.1.el6.x86_64).  We installed a LSI 9201-16e SAS HBA in it,
>> upgraded to the latest firmware (9116 chipset).  Then we attached a LSI
>> DE2660 JBOD array to it, with 60 hard drives.
>
> TTBOMK LSI never made a 60 drive JBOD chassis.  Is this actually 3x 24
> bay JBOD chassis daisy chained?  Did you buy them on Ebay or are these
> simply being redeployed?  All LSI drive chassis, both JBOD and SAN/DAS
> RAID, have been discontinued for quite a while.

Technically it is a E2660 Engenio "expansion" Array.  These arrays are 
indeed 60 disks (in 4RU), they are front loading with 5 12-disk "trays" 
connected to a common backplane.  NetApp recently acquired the LSI 
Engenio division, so I guess really it isn't LSI anymore, but now 
NetApp.  It was purchased like 4 months ago right before NetApp took 
over the group.

> First remove and re-seat all SFF8088 cables.  Then replace them one by
> one until the errors/problems are eliminated.  If not test each chassis
> expander module individually with only one in the chassis.  Test it in
> both module bays.  Basic process of elimination stuff.

I've not tried it with only one expander in the chassis, good idea.

> Given you're receiving errors on multiple drives I'd say you have a bad:
>
> 1.  Cable
> 2.  Backplane
> 3.  Expander module
> 4.  PSU

Yeah something is weird, I seem to be receiving errors on every single 
drive.  Either it's a driver issue or maybe even with the HBA, or 
something weird with the array/backplane.

Thanks for the reply!

cheers,
erich
