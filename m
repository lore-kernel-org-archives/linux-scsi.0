From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2.6.30] libsrp: fix memory leak in srp_ring_free()
Date: Sat, 5 Sep 2009 18:20:53 +0900
Message-ID: <20090905182034M.fujita.tomonori@lab.ntt.co.jp>
References: <e2e108260908300336p777654bbw2f0b1eef9b6858c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:35306 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbZIEJVF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Sep 2009 05:21:05 -0400
In-Reply-To: <e2e108260908300336p777654bbw2f0b1eef9b6858c@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bart.vanassche@gmail.com
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, tomof@acm.org

On Sun, 30 Aug 2009 12:36:48 +0200
Bart Van Assche <bart.vanassche@gmail.com> wrote:

> This patch fixes a memory leak in the libsrp function srp_ring_free().
> It is not documented whether or not this function should free the ring
> pointer itself. But the source code of the callers of this function
> (srp_target_alloc() and srp_target_free()) makes it clear that
> srp_ring_free() should deallocate the ring pointer itself. Furthermore,
> the patch below makes srp_ring_free() deallocate all memory allocated by
> srp_ring_alloc().
> 
> This patch affects the ibmvstgt driver, which is the only in-tree driver
> that calls the srp_ring_free() function (indirectly).
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
> Cc: James Bottomley <James.Bottomley@suse.de>
> Cc: FUJITA Tomonori <tomof@acm.org>

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Better to add:

Cc: stable@kernel.org


Thanks,
