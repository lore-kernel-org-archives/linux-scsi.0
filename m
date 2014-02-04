From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Re-sync module parameter descriptions with the
 code
Date: Tue, 4 Feb 2014 15:09:22 -0500
Message-ID: <alpine.WNT.2.00.1402041508290.5360@N5102REMCQXM4BS.qlogic.org>
References: <1391539835-8431-1-git-send-email-steve@digidescorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1391539835-8431-1-git-send-email-steve@digidescorp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Steven J. Magnani" <steve.magnani@digidescorp.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Steven J. Magnani" <steve@digidescorp.com>
List-Id: linux-scsi@vger.kernel.org



On Tue, 4 Feb 2014, Steven J. Magnani wrote:

> Fix module parameter descriptions mentioning default values that no longer
> match the code.
>
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN linux-3.14-rc1/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> --- linux-3.14-rc1/drivers/scsi/qla2xxx/qla_os.c	2014-02-02 18:42:13.000000000 -0600
> +++ b/drivers/scsi/qla2xxx/qla_os.c	2014-02-04 12:41:45.133576764 -0600
> @@ -120,15 +120,17 @@ MODULE_PARM_DESC(ql2xmaxqdepth,
> int ql2xenabledif = 2;
> module_param(ql2xenabledif, int, S_IRUGO);
> MODULE_PARM_DESC(ql2xenabledif,
> -		" Enable T10-CRC-DIF "
> -		" Default is 0 - No DIF Support. 1 - Enable it"
> -		", 2 - Enable DIF for all types, except Type 0.");
> +		" Enable T10-CRC-DIF:\n"
> +		" Default is 2.\n"
> +		"  0 -- No DIF Support\n"
> +		"  1 -- Enable DIF for all types\n"
> +		"  2 -- Enable DIF for all types, except Type 0.\n");
>
> int ql2xenablehba_err_chk = 2;
> module_param(ql2xenablehba_err_chk, int, S_IRUGO|S_IWUSR);
> MODULE_PARM_DESC(ql2xenablehba_err_chk,
> 		" Enable T10-CRC-DIF Error isolation by HBA:\n"
> -		" Default is 1.\n"
> +		" Default is 2.\n"
> 		"  0 -- Error isolation disabled\n"
> 		"  1 -- Error isolation enabled only for DIX Type 0\n"
> 		"  2 -- Error isolation enabled for all Types\n");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Looks good. Thanks.

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>
