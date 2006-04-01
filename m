From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] move ->eh_strategy_handler to the transport class
Date: Sat, 01 Apr 2006 13:10:28 -0500
Message-ID: <442EC214.1040303@garzik.org>
References: <20060401172104.GA16921@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060401172104.GA16921@lst.de>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> Overriding the whole EH code is a per-transport, not per-host thing.
> Move ->eh_strategy_handler to the transport class, same as
> ->eh_timed_out.
> 
> Downside is that scsi_host_alloc can't check for the total lack of EH
> anymore, but the transition period from old EH where we needed it is
> long gone already.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.  I agree the transport the better place for 
eh_strategy_handler.

I would prefer to merge it through the libata-dev queue, since -- as a 
glance through the recent kernel changelog shows -- Tejun Heo has been 
ripping through this part of libata as well.

	Jeff



