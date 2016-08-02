From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH 0082/1285] Replace numeric parameter like 0444 with
 macro
Date: Tue, 2 Aug 2016 08:56:50 -0400 (EDT)
Message-ID: <189828785.7811267.1470142610748.JavaMail.zimbra@redhat.com>
References: <20160802103914.19225-1-baolex.ni@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:56929 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965826AbcHBM5Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2016 08:57:16 -0400
In-Reply-To: <20160802103914.19225-1-baolex.ni@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baole Ni <baolex.ni@intel.com>
Cc: don brace <don.brace@microsemi.com>, len brown <len.brown@intel.com>, pavel@ucw.cz, gregkh@linuxfoundation.org, hpa@zytor.com, x86@kernel.org, iss storagedev <iss_storagedev@hp.com>, esc storagedev <esc.storagedev@microsemi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chuansheng liu <chuansheng.liu@intel.com>



----- Original Message -----
> From: "Baole Ni" <baolex.ni@intel.com>
> To: "don brace" <don.brace@microsemi.com>, "len brown" <len.brown@intel.com>, pavel@ucw.cz,
> gregkh@linuxfoundation.org, hpa@zytor.com, x86@kernel.org
> Cc: "iss storagedev" <iss_storagedev@hp.com>, "esc storagedev" <esc.storagedev@microsemi.com>,
> linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "chuansheng liu" <chuansheng.liu@intel.com>, "baolex ni"
> <baolex.ni@intel.com>
> Sent: Tuesday, August 2, 2016 6:39:14 AM
> Subject: [PATCH 0082/1285] Replace numeric parameter like 0444 with macro
> 
> I find that the developers often just specified the numeric value
> when calling a macro which is defined with a parameter for access permission.
> As we know, these numeric value for access permission have had the
> corresponding macro,
> and that using macro can improve the robustness and readability of the code,
> thus, I suggest replacing the numeric parameter with the macro.
> 
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> Signed-off-by: Baole Ni <baolex.ni@intel.com>
> ---
>  drivers/block/cciss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 63c2064..05dc1bd 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -67,7 +67,7 @@ MODULE_SUPPORTED_DEVICE("HP Smart Array Controllers");
>  MODULE_VERSION("3.6.26");
>  MODULE_LICENSE("GPL");
>  static int cciss_tape_cmds = 6;
> -module_param(cciss_tape_cmds, int, 0644);
> +module_param(cciss_tape_cmds, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
>  MODULE_PARM_DESC(cciss_tape_cmds,
>  	"number of commands to allocate for tape devices (default: 6)");
>  static int cciss_simple_mode;
> --
> 2.9.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Looks fine: 
Reviewed by: Laurence Oberman <loberman@redhat.com>
