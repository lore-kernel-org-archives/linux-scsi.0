From: "Mukker, Atul" <atulm@lsil.com>
Subject: RE: Cannot get device recognized on a megaraid
Date: Mon, 24 Nov 2003 18:00:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC1D1@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:2302 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261602AbTKXXAi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 18:00:38 -0500
Received: from mhbs.lsil.com (mhbs.lsil.com [147.145.31.100])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id hAOLkndI022432
	for <linux-scsi@vger.kernel.org>; Mon, 24 Nov 2003 14:58:03 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: 'Micah Anderson' <micah@riseup.net>, linux-scsi@vger.kernel.org

I am sure you have an older megaraid driver on the system, which does not
support your controller. Can you elaborate on the controller and the driver
version.

Thanks
-Atul Mukker
LSI Logic Corporation

> -----Original Message-----
> From: Micah Anderson [mailto:micah@riseup.net]
> Sent: Monday, November 24, 2003 11:31 AM
> To: linux-scsi@vger.kernel.org
> Subject: Cannot get device recognized on a megaraid
> 
> 
> Hi,
> 
> I've been fighting a megaraid card with one device, just trying to get
> it recognized. The card has the latest bios, the drive is in a RAID 0
> container. Boot up doesn't show it at all:
> 
>  megaraid: no BIOS enabled.
>  
>  There are two other scsi devices that we have on the 
> machine, they are
>  recognized fine:
>  
>  Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
>  Attached scsi disk sdb at scsi1, channel 0, id 2, lun 0
>  SCSI device sda: 17783240 512-byte hdwr sectors (9105 MB)
>  Partition check:
>   sda: sda1 sda2 sda3 sda4
>  sym53c875-0-<2,*>: FAST-20 SCSI 20.0 MB/s (50.0 ns, offset 15)
>  SCSI device sdb: 8888924 512-byte hdwr sectors (4551 MB)
>   sdb: sdb1
> 
> What do we need to do to get the drive attached to the megaraid card
> recognized? 
> 
> Thanks,
> micah
> 
> 
>  
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
