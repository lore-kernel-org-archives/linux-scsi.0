From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/3] convert flush to REQ_TYPE_FS instead of
 REQ_TYPE_BLOCK_PC
Date: Wed, 21 Jul 2010 11:15:42 +0900
Message-ID: <20100721111502B.fujita.tomonori@lab.ntt.co.jp>
References: <1278635906-16400-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:37311 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762021Ab0GUCR0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 22:17:26 -0400
In-Reply-To: <1278635906-16400-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On Fri,  9 Jul 2010 09:38:23 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> This is the second version of flush REQ_TYPE_FS conversion:
> 
> http://marc.info/?l=linux-scsi&m=127730591527424&w=2
> 
> There is no major changes since the first version. Just minor
> adjustment for the discard changes.
> 
> This can be applied to block's for-2.6.36.
> 
> The git tree is also available:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git fs-flush
> 
> =
>  block/blk-barrier.c       |    3 ++-
>  drivers/scsi/scsi_error.c |   19 ++++---------------
>  drivers/scsi/sd.c         |    2 --
>  3 files changed, 6 insertions(+), 18 deletions(-)

Jens, any reason why this flush conversion isn't included in your
for-2.6.36 yet? I've just confirmed that this can be still applied
cleanly.
