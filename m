From: Jindrich Makovicka <makovick@kmlinux.fjfi.cvut.cz>
Subject: Re: 2.6.13-rc3-mm1: horribly drivers/scsi/qla2xxx/Makefile
Date: Sat, 16 Jul 2005 19:26:44 +0200
Message-ID: <dbbg0k$p8g$1@sea.gmane.org>
References: <20050715013653.36006990.akpm@osdl.org> <20050715102744.GA3569@stusta.de> <20050715144037.GA25648@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261769AbVGPR3N@vger.kernel.org>
In-Reply-To: <20050715144037.GA25648@plap.qlogic.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Andrew Vasquez wrote:
> Yes, quite.  How about the following to correct the intention.
> 
> 
> 
> Add correct Kconfig option for ISP24xx support.
> 
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> ---
> 
> diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
> --- a/drivers/scsi/qla2xxx/Kconfig
> +++ b/drivers/scsi/qla2xxx/Kconfig
> @@ -39,3 +39,11 @@ config SCSI_QLA6312
>  	---help---
>  	This driver supports the QLogic 63xx (ISP6312 and ISP6322) host
>  	adapter family.
> +
> +config SCSI_QLA24XX
> +	tristate "QLogic ISP24xx host adapter family support"
> +	depends on SCSI_QLA2XXX
> +        select SCSI_FC_ATTRS

there should be also "select FW_LOADER", as it uses request_firmware &
release_firmware

> +	---help---
> +	This driver supports the QLogic 24xx (ISP2422 and ISP2432) host
> +	adapter family.

-- 
Jindrich Makovicka
