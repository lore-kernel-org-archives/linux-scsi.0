From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/3] sg: kill unused SZ_SG_IOVEC define
Date: Wed, 01 Apr 2009 12:40:06 -0400
Message-ID: <49D398E6.6070907@interlog.com>
References: <1236733367-30967-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54568 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760325AbZDAQkQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2009 12:40:16 -0400
In-Reply-To: <1236733367-30967-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/sg.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 17d1bd5..e84536b 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -204,7 +204,6 @@ static void sg_put_dev(Sg_device *sdp);
>  
>  #define SZ_SG_HEADER sizeof(struct sg_header)
>  #define SZ_SG_IO_HDR sizeof(sg_io_hdr_t)
> -#define SZ_SG_IOVEC sizeof(sg_iovec_t)
>  #define SZ_SG_REQ_INFO sizeof(sg_req_info_t)
>  
>  static int sg_allow_access(struct file *filp, unsigned char *cmd)

For this patch:
   [PATCH 1/3] sg: kill unused SZ_SG_IOVEC define
plus:
   [PATCH 2/3] sg: remove unnecessary type casts
   [PATCH 3/3] sg: remove unnecessary forward declaration
originally submitted 20090310

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

