From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: qla2xxx (2100) vs. qlogicfc [again]
Date: Thu, 6 May 2004 13:34:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060EE83@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:15671 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S261991AbUEFUfh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 May 2004 16:35:37 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Ricky Beam <jfbeam@bluetronic.net>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>


On Thursday, May 06, 2004 10:46 AM, linux-scsi-owner@vger.kernel.org
wrote: 
> 
> [options qla2xxx
>   ql2xlogintimeout=30 qlport_down_retry=10
>

You do not need to pass the following parameters when loading the
driver:

>   ql2xplogiabsentdevice=1
>   ql2xdoinitscan=1


> (qla2100)
> QLogic Fibre Channel HBA Driver (f8c16000)
> qla2100 0000:06:03.0: Found an ISP2100, irq 24, iobase 0xf8b15000
> qla2100 0000:06:03.0: Configuring PCI space...
> qla2100 0000:06:03.0: Configure NVRAM parameters...
> qla2100 0000:06:03.0: Verifying loaded RISC code...
> qla2100 0000:06:03.0: Waiting for LIP to complete...
> qla2100 0000:06:03.0: Cable is unplugged...
>  [no it isn't. the hub shows it active and the switch shows
> it logged in.]
<snip>
> The card's BIOS can see all the disks.  The old qlogicfc driver can
> see all the drives.  However, the new qla2xxx driver will never see
> the loop as active.  Keep in mind, it takes a few seconds (2) for
> the hub to re-enable the port and put the HBA back in the loop.
> 

I have a batch of patches pending for submission that I'll have a
chance to get to tonight.  In the interim, could you download this
driver:

	ftp://ftp.qlogic.com/outgoing/linux/beta/8.x/qla2xxx-src-v8.00.00b12.tar.bz2

Enable some select debug settings:

        o DEBUG_QLA2100 set to 1 in qla_settings.h 

        o QL_DEBUG_LEVEL_2 defined in qla_dbg.h 

Recompile, reload the driver, and forward over the relevant snippets
from var/log/messages.

> If the guys at Qlogic want to watch what I'm seeing, all they have
> to do is ask.
> 

SSH access?

> PS: If someone wants to give me a QLA2300, I won't complain :-)
> 

I'm tempted... try ebay:

	http://cgi.ebay.com/ws/eBayISAPI.dll?ViewItem&category=44994&item=3095100926&rd=1&ssPageName=WDVW

20 bucks, 5days left to bid :p

Regards,
Andrew Vasquez
