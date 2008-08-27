From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH]: scsi_dh: no need to memset cmd
Date: Wed, 27 Aug 2008 10:29:18 +0900
Message-ID: <20080827102900R.fujita.tomonori@lab.ntt.co.jp>
References: <1219697518.14830.123.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:43297 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbYH0BcZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2008 21:32:25 -0400
In-Reply-To: <1219697518.14830.123.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@us.ibm.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Mon, 25 Aug 2008 13:51:58 -0700
Chandra Seetharaman <sekharan@us.ibm.com> wrote:

> Hi James,
> 
> I resent Fujita's patch a while back, But it didn't make it yet to
> 2.6.27 (just checked rc4). Can you please apply.

Probably, this is not rc4 material.

James, can you apply this to scsi-misc?

> 
> chandra
> ----------------
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] scsi_dh: no need to initialize rq->cmd with blk_get_request
> 
> blk_get_request initializes rq->cmd (rq_init does) so the users don't
> need to do that.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_emc.c   |    1 -
>  drivers/scsi/device_handler/scsi_dh_hp_sw.c |    2 --
>  drivers/scsi/device_handler/scsi_dh_rdac.c  |    2 --
>  3 files changed, 0 insertions(+), 5 deletions(-)
