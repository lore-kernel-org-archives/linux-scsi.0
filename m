From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] move ->eh_strategy_handler to the transport class
Date: Sat, 01 Apr 2006 21:58:32 +0200
Message-ID: <442EDB68.2060707@s5r6.in-berlin.de>
References: <20060401172104.GA16921@lst.de> <1143914189.3076.20.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:26090 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751611AbWDAT6q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Apr 2006 14:58:46 -0500
In-Reply-To: <1143914189.3076.20.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Arjan van de Ven wrote:
> On Sat, 2006-04-01 at 19:21 +0200, Christoph Hellwig wrote:
>>Overriding the whole EH code is a per-transport, not per-host thing.
>>Move ->eh_strategy_handler to the transport class, same as
>>->eh_timed_out.
> 
> I like it, nice cleanup and it's fundamentally the right place to do it

BTW, why are there Scsi_Hosts in (s)ata drivers anyway instead of being 
hidden by libata? (Think of libata---or a transport class---as a layer.)
-- 
Stefan Richter
-=====-=-==- -=-- ----=
http://arcgraph.de/sr/
