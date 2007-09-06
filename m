From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: adding lsi MegaRaid SAS 8208ELP support to fusion
Date: Thu, 6 Sep 2007 14:21:50 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7096C264@NAMAIL4.ad.lsil.com>
References: <1189103995.6180.56.camel@lgelinas>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:33654 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757523AbXIFUVy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Sep 2007 16:21:54 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1189103995.6180.56.camel@lgelinas>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Louis-Michel Gelinas <lgelinas@coradiant.com>, linux-scsi <linux-scsi@vger.kernel.org>

On September 06, 2007 12:40 PM,  Louis-Michel Gelinas wrote:
> 
> After messing around with various kernels and drivers, I finnaly got
> this adaptor to work by changing the define 
> MPI_MANUFACTPAGE_DEVID_SAS1068E to (0x0059) from (0x0058) in 
> 
> drivers/message/fusion/lsi/mpi_cnfg.h:553
> 
> I understand this is not the preferred method to say the 
> least. However,
> it is the only way I could this adaptor running, also my tests show it
> to be stable...
> 
> Should I submit a proper patch? Shouldn't this card use the 
> megaraid_sas
> driver ?!
> 
> Please indicate against which git url I should base my patch. 
> 
> I am using 2.6.21.3 but I believe this change can be applied to any
> kernel/git. 
> 

The driver that works with the (0x59) pci_device_id is megasr.    You
will need to contact the megaraid folks to obtain those sources, as its
not supplied in the linux kernel.  Please don't supply any patch against
fusion to support that, as I will reject it.

Eric Moore
