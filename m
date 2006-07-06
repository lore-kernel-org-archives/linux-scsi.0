From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [KJ] [PATCH] fix legacy megaraid-driver to compile without
 CONFIG_PROC_FS
Date: Thu, 6 Jul 2006 13:14:47 -0700
Message-ID: <20060706131447.ed46c3cb.rdunlap@xenotime.net>
References: <44AD6A5A.5060403@nachtwindheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:44439 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1750802AbWGFUMB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jul 2006 16:12:01 -0400
Received: from midway.site ([71.117.253.75]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 6 Jul 2006 13:12:01 -0700
In-Reply-To: <44AD6A5A.5060403@nachtwindheim.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Henne <henne@nachtwindheim.de>
Cc: Neela.Kolli@engenio.com, kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 06 Jul 2006 21:54:02 +0200 Henne wrote:

> From: Henrik Kretzschmar <henne@nachtwindheim.de>
> 
> Create an empty inline function to make the legacy megaraid-driver compile
> without PROC_FS.
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
> ---
> 
> --- linux-2.6.18-rc1/drivers/scsi/megaraid.h    2006-06-18 03:49:35.000000000 +0200
> +++ linux/drivers/scsi/megaraid.h       2006-07-06 21:39:59.000000000 +0200
> @@ -1039,6 +1039,9 @@
>  static int proc_rdrv_30(char *, char **, off_t, int, int *, void *);
>  static int proc_rdrv_40(char *, char **, off_t, int, int *, void *);
>  static int proc_rdrv(adapter_t *, char *, int, int);
> +#else
> +static inline void
> +mega_create_proc_entry(int index, struct proc_dir_entry *parent) {}
>  #endif
> 
>  static int mega_adapinq(adapter_t *, dma_addr_t);

Already in -mm:
http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.17/2.6.17-mm6/broken-out/drivers-scsi-megaraidc-add-a-dummy-mega_create_proc_entry-for-proc_fs=y.patch


---
~Randy
