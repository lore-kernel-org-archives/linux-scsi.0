From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fix dma mapping leak in fusion
Date: Thu, 19 Aug 2004 12:14:34 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040819101433.GA20353@lst.de>
References: <20040817161642.GA16509@lst.de> <200408190301.AA03490@fukuchi.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:24740 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264954AbUHSKOq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 06:14:46 -0400
Content-Disposition: inline
In-Reply-To: <200408190301.AA03490@fukuchi.jp.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org
To: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@lst.de>, moore@lsil.com, linux-scsi@vger.kernel.org

On Thu, Aug 19, 2004 at 12:01:11PM +0900, Masao Fukuchi wrote:
> Hi Christoph,
> 
> I applyed attached patch into latest fusion MPT driver(3.01.15) and
> tested it, but I still met Oops.
> Then I also applyed your latest patch(it gets rid of the fusion pendingQ
> in favour of using the scsi midlayer queuing), but I met Oops again.

Can you try the patch Eric posted instead?

