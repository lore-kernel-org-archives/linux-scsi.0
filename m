From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [rant] can we get asane ic7xxx/79xx probing _please_
Date: Wed, 08 Sep 2004 09:46:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <413F0D26.5020601@adaptec.com>
References: <20040906182402.GA25103@lst.de>  <413F01C3.9020202@adaptec.com> <1094649419.2800.12.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:15271 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S268328AbUIHNqV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2004 09:46:21 -0400
In-Reply-To: <1094649419.2800.12.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 2004-09-08 at 14:57, Luben Tuikov wrote:
> 
>>Hi Christoph,
>>
>>Thanks for bringing this up.  I do have Andi's patch in the pending list,
>>and would like to apply it to the newer version of the driver.
>>
>>I should mention that while the newer drivers do not quite have
>>the PCI tables as presented in Andi's patch, they do check the return
>>value of pci_module_init() and return the appropriate result.
> 
> 
> please please please provide linux compliant MODULE_DEVICE_TABLE's.
> Operating system hardware probing apps *require* those for device
> probing; right now there are very ugly hacks especially for aic7xxx that
> should go away.
> 

Yes Arjan, I agree.

		Luben


