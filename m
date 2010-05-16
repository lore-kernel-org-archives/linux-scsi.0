From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/8] block: restart partition scan after resizing a
 device
Date: Sun, 16 May 2010 00:15:02 -0700 (PDT)
Message-ID: <20100516.001502.35836083.davem@davemloft.net>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
	<1273946974-29131-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1273946974-29131-3-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, ben@decadent.org.uk, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Sat, 15 May 2010 20:09:28 +0200

> Device resize via ->set_capacity() can reveal new partitions (e.g. in
> chained partition table formats such as dos extended parts).  Restart
> partition scan from the beginning after resizing a device.  This
> change also makes libata always revalidate the disk after resize which
> makes lower layer native capacity unlocking implementation simpler and
> more robust as resize can be handled in the usual path.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Ben Hutchings <ben@decadent.org.uk>

Acked-by: David S. Miller <davem@davemloft.net>
