From: Stas Nikiforov <stas@itam.nsc.ru>
Subject: RE: megaraid aborting problem (RHEL 3WS)
Date: Fri, 17 Sep 2004 14:55:40 +0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095407740.7060.5.camel@whirl.lab7.lan>
References: <7076215DFAA4574099E5CD59FE422262050538CE@pcssrv42.pcs.pc.ome.toshiba.co.jp>
Reply-To: stas@itam.nsc.ru
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.itam.nsc.ru ([194.226.179.15]:54415 "EHLO ns.itam.nsc.ru")
	by vger.kernel.org with ESMTP id S268534AbUIQH4U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2004 03:56:20 -0400
In-Reply-To: <7076215DFAA4574099E5CD59FE422262050538CE@pcssrv42.pcs.pc.ome.toshiba.co.jp>
List-Id: linux-scsi@vger.kernel.org
To: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Cc: Linux-scsi list <linux-scsi@vger.kernel.org>

Hi,

Sorry for a very long delay. I try to do some things with hardware.

I have 2.4.21-20EL,
WD 6xHDD SATA DISK drive 250GB,
RAID 5, LSI firmware [713G:G117]

I've get the nvram log from the controller. 
Here it is.

LOG 48356182 event 0x390 time .....
Channel 0, Targed 255, lun 0
Code: 0x390
Category: i960 Hardware Error Event

My vendor told me to re-write firmware,
check all HDDs and re-initialize RAID. 
Now I do these things.

Stas.

On Fri, 2004-09-10 at 09:46, Tomita, Haruo wrote: 
> Hi all
> 
> > megaraid: aborting-1441961 cmd=2a <c=0 t=0 l=0>
> 
> Please let me know the environment which
> the abort issue of megaraid2 driver.
> 
>    - vender name of HDD
>    - HDD fw version
>    - RAID level
>    - raid controller's FW version.
> 
> I used three disks of Hitachi (Daytona S28B),
> and constituted them RAID5. 
> The same error is experienced by 2.4.21-15.04EL.
> megaraid2 driver is 2.10.3, raid fw is 1T23.
> 
> Best regards,
> Haruo

