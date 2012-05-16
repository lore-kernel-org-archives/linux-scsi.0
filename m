From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 10/10] sg: constify sg_proc_leaf_arr
Date: Wed, 16 May 2012 17:58:00 -0400
Message-ID: <4FB422E8.3030001@interlog.com>
References: <20120412213217.GA17388@logfs.org> <20120412213524.GJ17388@logfs.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54432 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759702Ab2EPV6R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 May 2012 17:58:17 -0400
In-Reply-To: <20120412213524.GJ17388@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On 12-04-12 05:35 PM, J=C3=B6rn Engel wrote:
> Signed-off-by: Joern Engel<joern@logfs.org>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/sg.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 0c646f2..5790358 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -2322,7 +2322,7 @@ struct sg_proc_leaf {
>   	const struct file_operations * fops;
>   };
>
> -static struct sg_proc_leaf sg_proc_leaf_arr[] =3D {
> +static const struct sg_proc_leaf sg_proc_leaf_arr[] =3D {
>   	{"allow_dio",&adio_fops},
>   	{"debug",&debug_fops},
>   	{"def_reserved_size",&dressz_fops},
> @@ -2342,7 +2342,7 @@ sg_proc_init(void)
>   	if (!sg_proc_sgp)
>   		return 1;
>   	for (k =3D 0; k<  num_leaves; ++k) {
> -		struct sg_proc_leaf *leaf =3D&sg_proc_leaf_arr[k];
> +		const struct sg_proc_leaf *leaf =3D&sg_proc_leaf_arr[k];
>   		umode_t mask =3D leaf->fops->write ? S_IRUGO | S_IWUSR : S_IRUGO;
>   		proc_create(leaf->name, mask, sg_proc_sgp, leaf->fops);
>   	}

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
