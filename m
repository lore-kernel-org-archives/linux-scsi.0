From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE] Generic SCSI Target Middle Level for Linux (SCST)
 with target drivers
Date: Thu, 17 Jun 2004 17:22:12 +0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <40D19B04.40702@vlnb.net>
References: <40D075DA.2000007@vlnb.net> <20040617122213.GA30943@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org-S266483AbUFQNVK@vger.kernel.org>
In-Reply-To: <20040617122213.GA30943@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Jun 16, 2004 at 08:31:22PM +0400, Vladislav Bolkhovitin wrote:
> 
  > The code looks pretty neat to me, there's a few issues I'd like to see
> addresses but that doesn't make sense before the 2.4 support is dropped
> and there's an actual LLDD for 2.6.  But I think for most interesting
> scenarios in the storage virtualization world your driver is pretty much
> useless because it wants to dispatch directly to a scsi device and doesn't
> go through the block layer.  So no fancy volume managers/etc there to make
> interesting storage virtualization boxes.
> 
For that is intended upcoming block device handler with block 
layer/cache support,
which will be in its exec() method check, if requested blocks in cache, 
and, if not, dispatch the commands to block layer, leaving regular 
scsi_do_req() calls for tapes, changers, etc. In the similar way "_perf" 
handlers work (they don't send READ/WRITE commands to SCSI devices for 
performance studies).

This device handler is on our todo list. Actually, it's quite simple and 
if anyone interested, he's help would be greatly appreciated.

Thanks,
Vlad
