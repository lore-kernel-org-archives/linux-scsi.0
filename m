From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 1/3] move cmd_filter from gendisk to request_queue
Date: Wed, 30 Jul 2008 16:10:54 -0400
Message-ID: <4890CACE.8010407@redhat.com>
References: <20080724123140V.fujita.tomonori@lab.ntt.co.jp> <1217063005-25083-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1217063005-25083-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156AbYG3ULU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2008 16:11:20 -0400
In-Reply-To: <1217063005-25083-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, dan.j.williams@intel.com, adel.gadllah@gmail.com, viro@ZenIV.linux.org.uk, dougg@torque.net, matthew@wil.cx

FUJITA Tomonori wrote:

> diff --git a/block/bsg.c b/block/bsg.c
> index 5a68b09..6c5c6f3 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
...
> @@ -87,6 +85,7 @@ struct bsg_command {
>  	int err;
>  	struct sg_io_v4 hdr;
>  	char sense[SCSI_SENSE_BUFFERSIZE];
> +	int has_write_perm;
>  };
>  
>  static void bsg_free_command(struct bsg_command *bc)

Why is this added?  It never seems to be used.

-- 
   Peter
