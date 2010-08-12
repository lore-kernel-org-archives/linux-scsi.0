From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH -next] firmware: ibft depends on SCSI
Date: Thu, 12 Aug 2010 10:31:38 -0400
Message-ID: <4C6405CA.3080701@redhat.com>
References: <20100811140009.6ff33109.sfr@canb.auug.org.au> <20100811103620.2d25d573.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20100811103620.2d25d573.randy.dunlap@oracle.com>
Sender: linux-next-owner@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Konrad Rzeszutek Wilk <konrad@kernel.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/11/2010 01:36 PM, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Prevent build errors when SCSI is not enabled:
> 
> iscsi_ibft.c:(.init.text+0x548d): undefined reference to `iscsi_boot_create_initiator'
> iscsi_ibft.c:(.init.text+0x54a9): undefined reference to `iscsi_boot_create_ethernet'
> iscsi_ibft.c:(.init.text+0x54c5): undefined reference to `iscsi_boot_create_target'
> iscsi_ibft.c:(.init.text+0x55ff): undefined reference to `iscsi_boot_destroy_kset'
> iscsi_ibft.c:(.init.text+0x561e): undefined reference to `iscsi_boot_create_kset'
> iscsi_ibft.c:(.exit.text+0xe2c): undefined reference to `iscsi_boot_destroy_kset'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc:	Peter Jones <pjones@redhat.com>
> Cc:	Konrad Rzeszutek Wilk <konrad@kernel.org>

This looks good to me, thanks for catching it.

Signed-of-by: Peter Jones <pjones@redhat.com>

> ---
>  drivers/firmware/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20100811.orig/drivers/firmware/Kconfig
> +++ linux-next-20100811/drivers/firmware/Kconfig
> @@ -125,7 +125,7 @@ config ISCSI_IBFT_FIND
>  config ISCSI_IBFT
>  	tristate "iSCSI Boot Firmware Table Attributes module"
>  	select ISCSI_BOOT_SYSFS
> -	depends on ISCSI_IBFT_FIND
> +	depends on ISCSI_IBFT_FIND && SCSI
>  	default	n
>  	help
>  	  This option enables support for detection and exposing of iSCSI
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
        Peter

RFC 882 put the dots in .com.

01234567890123456789012345678901234567890123456789012345678901234567890123456789
