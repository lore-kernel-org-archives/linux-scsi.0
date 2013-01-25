From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Initialize the sglist
Date: Fri, 25 Jan 2013 14:29:34 +0800
Message-ID: <5102264E.9020604@cn.fujitsu.com>
References: <1359075861-1014-1-git-send-email-kys@microsoft.com>
Reply-To: gaowanlong@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28834 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab3AYG3q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jan 2013 01:29:46 -0500
In-Reply-To: <1359075861-1014-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com, linux-scsi@vger.kernel.org, Stable <stable@vger.kernel.org>, Wanlong Gao <gaowanlong@cn.fujitsu.com>

On 01/25/2013 09:04 AM, K. Y. Srinivasan wrote:
> Properly initialize scatterlist before using it.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: Stable <stable@vger.kernel.org>

Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

> ---
>  drivers/scsi/storvsc_drv.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 270b3cf..5ada1d0 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -467,6 +467,7 @@ static struct scatterlist *create_bounce_buffer(struct scatterlist *sgl,
>  	if (!bounce_sgl)
>  		return NULL;
>  
> +	sg_init_table(bounce_sgl, num_pages);
>  	for (i = 0; i < num_pages; i++) {
>  		page_buf = alloc_page(GFP_ATOMIC);
>  		if (!page_buf)
> 

