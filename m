From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 3/8] block,ide: simplify bdops->set_capacity() to
 ->unlock_native_capacity()
Date: Sun, 16 May 2010 00:15:52 -0700 (PDT)
Message-ID: <20100516.001552.85431321.davem@davemloft.net>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
	<1273946974-29131-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1273946974-29131-4-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, ben@decadent.org.uk, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Sat, 15 May 2010 20:09:29 +0200

> bdops->set_capacity() is unnecessarily generic.  All that's required
> is a simple one way notification to lower level driver telling it to
> try to unlock native capacity.  There's no reason to pass in target
> capacity or return the new capacity.  The former is always the
> inherent native capacity and the latter can be handled via the usual
> device resize / revalidation path.  In fact, the current API is always
> used that way.
> 
> Replace ->set_capacity() with ->unlock_native_capacity() which take
> only @disk and doesn't return anything.  IDE which is the only current
> user of the API is converted accordingly.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
