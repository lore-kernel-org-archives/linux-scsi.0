From: Jan Bakuwel <jan.bakuwel@int.greenpeace.org>
Subject: Re: Marvell SATA status
Date: Wed, 18 Jan 2006 18:05:28 +0100
Message-ID: <43CE7558.3060505@int.gl3>
References: <43CD67E1.7080703@int.gl3> <43CD86C7.80806@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.greenpeace.org ([212.19.215.77]:42480 "EHLO
	fw.greenpeace.org") by vger.kernel.org with ESMTP id S1751375AbWARRHZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jan 2006 12:07:25 -0500
In-Reply-To: <43CD86C7.80806@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

Hoi Jeff,

> Note that the Marvell chip is not RAID.  See 
> http://linux.yyz.us/sata/faq-sata-raid.html

The Marvell chip isn't listed on that page unless my eye sight is 
deterioting :-)

The BIOS identifies it as an Adaptec HostRAID 6041 controller (?), 
allows for setting up the arrays etc, however, 'lspci -vv' identifies it 
as a Marvell Technology  MV88SX6041 RAID controller.

It could indeed be software RAID by controller, but as far as the OS is 
concerned the controller presents the array to the OS as a single disc...

> You will have better luck on the linux-ide list, though there admittedly 
> aren't a lot of sata_mv hackers.

Will have a look there too, thanks.

> Patches are certainly welcome.  sata_mv needs some more errata 
> workarounds before it could be said to be ready for production.

The current driver doesn't work:

sys1:~# dd if=/dev/zero of=/dev/sdb bs=1 count=1
1+0 records in
1+0 records out
1 bytes transferred in 61.346053 seconds (0 bytes/sec)
sys1:~#

So it does recognise the drive but nothing else happens.

I certainly won't be able to complete the driver by myself... so if 
there's little interest in it my only option would be to use the 3ware 
controller...

Thanks for your help,

Jan


-- 

A journalist once asked the late Gandhi what he thought of the western
civilization. Gandhi replied: "Western Civilization? That would be a
good idea!".

----

Ships Unit
Information, Communication, Technology
Greenpeace International
Ottho Heldringstraat 5
1066 AZ  AMSTERDAM
Netherlands (MET)

direct    +31 (0)20 7182084
fax       +31 (0)20 5148151
reception +31 (0)20 5148150
email     jan.bakuwel&int.greenpeace.org
private   jan.bakuwel&hccnet.nl
(replace & by @ in the emailaddress)

