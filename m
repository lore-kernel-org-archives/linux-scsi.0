From: "Mohan Kumar M." <MohanKumarM@AmiIndia.co.in>
Subject: Re: Driver Problem
Date: Thu, 17 Jul 2003 15:54:01 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <00c701c34c4d$8e0a0540$5b00000a@RiseOfMachine>
References: <005e01c34c40$20383bc0$5b00000a@RiseOfMachine>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="x-user-defined"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [203.129.222.186] ([203.129.222.186]:3589 "EHLO miami.chance")
	by vger.kernel.org with ESMTP id S271372AbTGQKEu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 06:04:50 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The problem I am facing in the driver is:

When I give
   dd if=/dev/zero of=/dev/sda bs=1024 count=100
It works, if I give
   dd if=/dev/zero of=/dev/sda bs=1024 count=1000 (Samething works in Kernel
2.4.18-3)
System crashes.

I am not using interrupt handler and scatter gather lists.

Here is my driver_template structure:

#define MY_SCSI \
{ \
 name: DRVR_NAME, \
 proc_info: myscsi_proc_info,\
 bios_param:myscsi_bios_param,\
 detect:myscsi_detect, \
 info:myscsi_info,\
 release:myscsi_release,\
 command:myscsi_command,\
 queuecommand:myscsi_queuecommand,\
 can_queue:0, \
 this_id:7,\
 cmd_per_lun:1,\
 sg_tablesize:SG_NONE, \
 unchecked_isa_dma:0,\
 highmem_io:1, \
}

          =-=
Thanks n Regards,
        Mohan.
          =-=
----- Original Message -----
From: "Mohan Kumar M." <MohanKumarM@AmiIndia.co.in>
To: <linux-scsi@vger.kernel.org>
Sent: Thursday, July 17, 2003 2:17 PM
Subject: Driver Problem

> Hi all,
> I have written a low level scsi driver for our scsi/raid controller.
>
> The driver is working fine in Kernel v.2.4.18-3, but its not working in
> Kernel v.2.4.19 onwards! (System crashes!!!!!)
>
> I am not using interrupts, SG Lists.
>
> Is SCSI subsystem has been changed from 2.4.18 to 2.4.19??
>
> Can anyone help me to solve this problem?


