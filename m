From: Stas Nikiforov <stas@itam.nsc.ru>
Subject: RE: (SOLVED) megaraid aborting problem (RHEL 3WS)
Date: Tue, 21 Sep 2004 14:15:16 +0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095750915.2726.35.camel@whirl.lab7.lan>
References: <7076215DFAA4574099E5CD59FE422262050538CE@pcssrv42.pcs.pc.ome.toshiba.co.jp>
	 <1095407740.7060.5.camel@whirl.lab7.lan>
Reply-To: stas@itam.nsc.ru
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.itam.nsc.ru ([194.226.179.15]:36780 "EHLO ns.itam.nsc.ru")
	by vger.kernel.org with ESMTP id S267494AbUIUHP1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 03:15:27 -0400
Received: from site.lan (itut.itam.nsc.ru [194.226.179.2])
	by ns.itam.nsc.ru (8.12.8/8.12.8) with ESMTP id i8L7FKI2025059
	for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2004 14:15:20 +0700
Received: from [192.168.7.215] ([192.168.7.215])
	(authenticated bits=0)
	by site.lan (8.12.11/8.12.11) with ESMTP id i8L7FG5d023540
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2004 14:15:16 +0700
In-Reply-To: <1095407740.7060.5.camel@whirl.lab7.lan>
List-Id: linux-scsi@vger.kernel.org
To: Linux-scsi list <linux-scsi@vger.kernel.org>

Hi,

I've re-write firmware, re-initialized RAID
and moved to kernel-2.4.20-RHEL.
I've passed IOZONE test and got no errors
on a controller.

Best regard,
Stas


On Fri, 2004-09-17 at 14:55, Stas Nikiforov wrote:
> Hi,
> 
> Sorry for a very long delay. I try to do some things with hardware.
> 
> I have 2.4.21-20EL,
> WD 6xHDD SATA DISK drive 250GB,
> RAID 5, LSI firmware [713G:G117]
> 
> I've get the nvram log from the controller. 
> Here it is.
> 
> LOG 48356182 event 0x390 time .....
> Channel 0, Targed 255, lun 0
> Code: 0x390
> Category: i960 Hardware Error Event
> 
> My vendor told me to re-write firmware,
> check all HDDs and re-initialize RAID. 
> Now I do these things.
> 
> Stas.
> 
> On Fri, 2004-09-10 at 09:46, Tomita, Haruo wrote: 
> > Hi all
> > 
> > > megaraid: aborting-1441961 cmd=2a <c=0 t=0 l=0>
> > 
> > Please let me know the environment which
> > the abort issue of megaraid2 driver.
> > 
> >    - vender name of HDD
> >    - HDD fw version
> >    - RAID level
> >    - raid controller's FW version.
> > 
> > I used three disks of Hitachi (Daytona S28B),
> > and constituted them RAID5. 
> > The same error is experienced by 2.4.21-15.04EL.
> > megaraid2 driver is 2.10.3, raid fw is 1T23.
> > 
> > Best regards,
> > Haruo
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

