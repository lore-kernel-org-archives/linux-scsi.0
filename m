From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [PATCH 2.6 ] MPT Fusion driver 3.01.00 update
Date: Wed, 10 Mar 2004 09:55:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57040DABAE@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:4339 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262256AbUCJOzQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 09:55:16 -0500
List-Id: linux-scsi@vger.kernel.org
To: Andreas Jellinghaus <aj@leogic.com>, linux-scsi@vger.kernel.org

I'm working on a fix for this. I should be
releasing sometime later this week.
The problem is one of the drives is running
at async narrow speeds. This only affects
RAID volumes.

Eric Moore


On Tuesday, March 09, 2004 11:14 AM, Andreas Jellinghaus wrote:
> 
> Hi Eric,
> 
> we are trying
> Fusion MPT base driver 3.00.02
> Copyright (c) 1999-2003 LSI Logic Corporation
> mptbase: Initiating ioc0 bringup
> ioc0: 53C1030: Capabilities={Initiator}
> Fusion MPT SCSI Host driver 3.00.02
> scsi0 : ioc0: LSI53C1030, FwRev=01030a00h, Ports=1, MaxQ=222, IRQ=26
>   Vendor: LSILOGIC  Model: 1030 IM       IM  Rev: 1000
>   Type:   Direct-Access                      ANSI SCSI revision: 02
> SCSI device sda: 143376384 512-byte hdwr sectors (73409 MB)
> SCSI device sda: drive cache: write back
>  sda: sda1 sda2 sda3 sda4
> Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
> Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0
>   Vendor: IBM       Model: 25P3495a S320  1  Rev: 1   
>   Type:   Processor                          ANSI SCSI revision: 02
> Attached scsi generic sg1 at scsi0, channel 0, id 8, lun 0,  type 3
> 
> as well as the 3.01.00 version on amd64 dual opteron machines
> on mainboards with amd chipset and two ibm 60Gb disks connected.
> 
> our problem: terrible speed when writing.
> we used dbench for benchmarking under linux 2.6.3
> and we get 1-2 mb/s :-(
> 
> Any idea how to solve this issue?
> Thanks for your help.
> 
> Regards, Andreas
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
