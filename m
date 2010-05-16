From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 5/8] block: improve automatic native capacity unlocking
Date: Sun, 16 May 2010 00:17:42 -0700 (PDT)
Message-ID: <20100516.001742.22051241.davem@davemloft.net>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
	<1273946974-29131-6-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1273946974-29131-6-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tj@kernel.org
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, ben@decadent.org.uk, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Sat, 15 May 2010 20:09:31 +0200

> Currently, native capacity unlocking is initiated only when a
> recognized partition extends beyond the end of the disk.  However,
> there are several other unhandled cases where truncated capacity can
> lead to misdetection of partitions.
> 
> * Partition table is fully beyond EOD.
> 
> * Partition table is partially beyond EOD (daisy chained ones).
> 
> * Recognized partition starts beyond EOD.
> 
> This patch updates generic partition check code such that all the
> above three cases are handled too.  For the first two, @state tracks
> whether low level partition check code tried to read beyond EOD during
> partition scan and triggers native capacity unlocking accordingly.
> The third is now handled similarly to the original unlocking case.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
