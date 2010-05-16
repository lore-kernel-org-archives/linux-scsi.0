From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 4/8] block: use struct parsed_partitions *state
 universally in partition check code
Date: Sun, 16 May 2010 00:16:52 -0700 (PDT)
Message-ID: <20100516.001652.267947899.davem@davemloft.net>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
	<1273946974-29131-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1273946974-29131-5-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, ben@decadent.org.uk, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Sat, 15 May 2010 20:09:30 +0200

> Make the following changes to partition check code.
> 
> * Add ->bdev to struct parsed_partitions.
> 
> * Introduce read_part_sector() which is a simple wrapper around
>   read_dev_sector() which takes struct parsed_partitions *state
>   instead of @bdev.
> 
> * For functions which used to take @state and @bdev, drop @bdev.  For
>   functions which used to take @bdev, replace it with @state.
> 
> * While updating, drop superflous checks on NULL state/bdev in ldm.c.
> 
> This cleans up the API a bit and enables better handling of IO errors
> during partition check as the generic partition check code now has
> much better visibility into what went wrong in the low level code
> paths.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
