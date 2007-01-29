From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: Fw: SAS1068 PCI-X Fusion-MPT SAS 1000:0055
Date: Mon, 29 Jan 2007 09:14:45 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D7055ECA0@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:59405 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbXA2QQG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2007 11:16:06 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, areq@areq.eu.org
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

On Friday, January 26, 2007 12:53 PM, Jun'ichi Nomura wrote: 
> Hi,
> 
> > I have new NEC server with SAS1068 PCI-X Fusion-MPT SAS
> > pciid: 1000:0055
> > mptsas form 2.6.20-rc5 don't recognize it ;(
> > 
> > I see that driver support only 1000:0054 and 1000:0058 devices.
> 
> It might be that the device has software RAID feature and changes
> device ID based on setup. (1000:0055 when software RAID is enabled
> and 1000:0054 or something for normal SAS)
> 
> If so, there is a chance you can disable the software RAID
> via BIOS setup utility.
> 
> Thanks,
> -- 
> Jun'ichi Nomura, NEC Corporation of America
>

You probably want to talk to the megaraid folks and see
if the have a driver for that.

I didn't submit a device id of 0055 to sourceforge.

The only 1068 ids that are clamied by mptsas is 0054 and 0058
which are the pcix and pcie solutions.   I notice that 0055 is
listed in repository, but it was not me that submitted that.
http://pci-ids.ucw.cz/iii/?i=1000 

Eric Moore
