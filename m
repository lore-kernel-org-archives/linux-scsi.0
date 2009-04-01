From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/3] sg: kill unused SZ_SG_IOVEC define
Date: Wed, 1 Apr 2009 23:03:41 +0900
Message-ID: <20090401230303H.fujita.tomonori@lab.ntt.co.jp>
References: <1236733367-30967-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo11.iij4u.or.jp ([210.138.174.81]:35096 "EHLO
	mfo11.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762487AbZDAOom (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2009 10:44:42 -0400
In-Reply-To: <1236733367-30967-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Wed, 11 Mar 2009 10:02:45 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

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
> -- 
> 1.6.0.6

Doug, can I get your ACKs on these patches? They just remove unused
code.

Thanks,
