From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [rant] can we get asane ic7xxx/79xx probing _please_
Date: Wed, 08 Sep 2004 09:44:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <413F0CC3.4020408@adaptec.com>
References: <20040906182402.GA25103@lst.de> <413F01C3.9020202@adaptec.com> <20040908130340.GA27693@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:21669 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S269144AbUIHNoo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2004 09:44:44 -0400
In-Reply-To: <20040908130340.GA27693@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Sep 08, 2004 at 08:57:39AM -0400, Luben Tuikov wrote:
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
> Luben, please stop that new version of the driver stuff.  Your job as
> a maintainer is to keep the driver in the kernel working, and your the
> steering point for getting right fixes in fast in a controlled way, the
> last thing we need is driver "releases" that batch up unrelated changes
> and are delayed forever.
> 
> So is Andi's (and my later fix okay) and can James apply them or not?

Yes they are okay and James can apply them.

		Luben


