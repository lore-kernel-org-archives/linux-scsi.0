From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [rant] can we get asane ic7xxx/79xx probing _please_
Date: Wed, 08 Sep 2004 08:57:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <413F01C3.9020202@adaptec.com>
References: <20040906182402.GA25103@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:27532 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265222AbUIHM5s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2004 08:57:48 -0400
In-Reply-To: <20040906182402.GA25103@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

Hi Christoph,

Thanks for bringing this up.  I do have Andi's patch in the pending list,
and would like to apply it to the newer version of the driver.

I should mention that while the newer drivers do not quite have
the PCI tables as presented in Andi's patch, they do check the return
value of pci_module_init() and return the appropriate result.

Thanks again,
		Luben



Christoph Hellwig wrote:
> Sorry to complain to you for Justins mess, but could you please fixup
> the damn pci probing?  Andi sent you a patch to add proper pci tables,
> and not ignoring the pci_module_init retval would be trivial if the
> module initialization wasn't split over three routines.
> 
> Curretly hotplug loads the adaptec drivers for every PCI scsi adapter
> in the system, see
> 
>         http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=270102
> 
> for details
> 

