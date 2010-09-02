From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bsg: call idr_pre_get() outside the lock.
Date: Thu, 2 Sep 2010 13:13:16 +0900
Message-ID: <20100902123544M.fujita.tomonori@lab.ntt.co.jp>
References: <m2eidda6bq.fsf@elisp.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:33471 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729Ab0IBENt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Sep 2010 00:13:49 -0400
In-Reply-To: <m2eidda6bq.fsf@elisp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: naota@elisp.net, JBottomley@Novell.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, axboe@kernel.dk, jkosina@suse.cz, gregkh@suse.de, daniel@caiaq.de, linux-scsi@vger.kernel.org

On Wed, 01 Sep 2010 23:26:01 +0900
Naohiro Aota <naota@elisp.net> wrote:

> The idr_pre_get() kernel-doc says "This function should be called
> prior to locking and calling the idr_get_new* functions.", but the
> idr_pre_get() calling in bsg_register_queue() is put inside
> mutex_lock(). Let's fix it.
> 
> Signed-off-by: Naohiro Aota <naota@elisp.net>
> ---
>  block/bsg.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Thanks,

James, can you merge this via your tree?
