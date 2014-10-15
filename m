From: David Miller <davem@davemloft.net>
Subject: Re: Sparc ESP problem with blk-mq
Date: Wed, 15 Oct 2014 16:53:24 -0400 (EDT)
Message-ID: <20141015.165324.1768019967735260346.davem@davemloft.net>
References: <alpine.LRH.2.11.1410140102230.18488@adalberg.ut.ee>
	<543D355A.3030605@kernel.dk>
	<20141015133551.GA15539@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:54199 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaJOUx3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Oct 2014 16:53:29 -0400
In-Reply-To: <20141015133551.GA15539@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: axboe@kernel.dk, mroos@linux.ee, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 15 Oct 2014 06:35:51 -0700

> On Tue, Oct 14, 2014 at 08:38:18AM -0600, Jens Axboe wrote:
>> Christoph, any idea on this? The command just times out, for some reason.
>> Only thing I could think of was related to perhaps missing bouncing or
>> similar, but I don't think that's the case. But the hba must not like the
>> request somehow. Or perhaps it sets up the wrong number of segments.
> 
> Seems like this is the first command we send.  I don't really have an
> idea at the moment, but it would be good to increase the scsi_logging
> level to the maximum and/or add some traces to the esp driver to figure
> out where the command gets lost.

I'll set aside some time to see if I can find anything obvious.

The ESP driver already has a deep, extensive, debug logging facility.
Just set the "esp_debug=xxx" option to something.  You can turn
everything on just by using something like "esp_debug=0x7ff"
