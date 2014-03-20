From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH 02/11][SCSI]mpt2sas: Added new driver module Parameter
 disable_eedp to Disable EEDP Support
Date: Thu, 20 Mar 2014 18:28:32 +0100
Message-ID: <532B2540.8050601@fastmail.fm>
References: <20140314153622.GA7947@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140314153622.GA7947@lsi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>, jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, linux-kernel@vger.kernel.org, sreekanthreddy0547@gmail.com
List-Id: linux-scsi@vger.kernel.org

>   	u8		scsi_io_cb_idx;
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index 7f0af4f..d502728 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -127,6 +127,11 @@ static int disable_discovery = -1;
>   module_param(disable_discovery, int, 0);
>   MODULE_PARM_DESC(disable_discovery, " disable discovery ");
>
> +/* Enable or disable EEDP support */
> +static int disable_eedp;
> +module_param(disable_eedp, uint, 0);
> +MODULE_PARM_DESC(disable_eedp, " disable EEDP support: (default=0)");

Wouldn't it make sense to exlain what EEDP means? Something like

MODULE_PARM_DESC(disable_eedp,
		" disable end-to-end data protection support (DIF): "
		"default=0)");
