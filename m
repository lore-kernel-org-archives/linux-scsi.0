From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 7/8] libata: use the enlarged capacity after late HPA
 unlock
Date: Sun, 16 May 2010 00:18:26 -0700 (PDT)
Message-ID: <20100516.001826.176644606.davem@davemloft.net>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
	<1273946974-29131-8-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1273946974-29131-8-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tj@kernel.org
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, ben@decadent.org.uk, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Sat, 15 May 2010 20:09:33 +0200

> After late HPA unlock, libata kept using the original capacity
> ignoring the new larger native capacity.  Enlarging device on the fly
> doesn't cause any harm.  Use the larger native capacity instead.  This
> will enable on-demand HPA unlocking.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
