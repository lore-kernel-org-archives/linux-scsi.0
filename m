From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [patch 1/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 09:22:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41596581.1030102@adaptec.com>
References: <41596126.7080502@adaptec.com> <20040928141547.A1871@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:32466 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267798AbUI1NWR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:22:17 -0400
In-Reply-To: <20040928141547.A1871@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Christoph Hellwig wrote:
> On Tue, Sep 28, 2004 at 09:03:34AM -0400, Luben Tuikov wrote:
> 
>>Sync up drivers/scsi/aic7xxx/. (2231-2232)
> 
> 
> This looks a lot like the internal command timeout handling that has been
> rejected.

That's true.  As there are other fixes alongside all the 205 patches
of AIC into our SCM, I wanted to level it off and submit the timeout,
dma, PCI fixes off of the latest version which we have here.

Those patches are simply for a review as other member of the community
wanted.  PCI, dma naming and timeout fixes would be off of those
so as to not lose other important fixes in the drivers.

	Luben

> Please stop "syncup" madness.  We couldn't care less what's in Adaptecs
> internal repository, especially if it's so bogus.  Please submit patches
> that actually fix things.  One patch per issue, with a proper explanation.
> 

