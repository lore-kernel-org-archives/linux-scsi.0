From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/3] block: completion related functions cleanup
Date: Thu, 14 May 2009 23:05:09 +0900
Message-ID: <4A0C2515.9060602@kernel.org>
References: <1242032169-22422-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <4A0C2297.5040001@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:60063 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbZENOFV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 May 2009 10:05:21 -0400
In-Reply-To: <4A0C2297.5040001@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> ---
>  drivers/scsi/scsi_lib.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index e410d66..f8600d6 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -789,7 +789,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  	 */
>  	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
>  		return;
> -	this_count = blk_rq_bytes(req);
>  
>  	error = -EIO;
>  

Nice spotting.  Looks like the variable can be killed completely?

Thanks.

-- 
tejun
