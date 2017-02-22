From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH] lpfc: add missing Kconfig NVME dependencies
Date: Wed, 22 Feb 2017 21:35:45 +0200
Message-ID: <e2550d34-6453-73b0-8470-7b6ff9fec73f@grimberg.me>
References: <58adba5f.BoP49Cv2S5zD9ZuD%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33256 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754927AbdBVTft (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2017 14:35:49 -0500
In-Reply-To: <58adba5f.BoP49Cv2S5zD9ZuD%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, hare@suse.com, martin.petersen@oracle.com, dick.kennedy@broadcom.com, linux-next@vger.kernel.org, sfr@canb.auug.org.au, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org


> add missing Kconfig NVME dependencies
>
> Can't believe I missed posting this
>
> -- james

Heh, the this sort of comment should come after
the '---' separator (below) unless you want it to live forever
in the git log...

>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---

[here]

>  drivers/scsi/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index d4023bf..2558434 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -1240,6 +1240,7 @@ config SCSI_LPFC
>  	tristate "Emulex LightPulse Fibre Channel Support"
>  	depends on PCI && SCSI
>  	depends on SCSI_FC_ATTRS
> +	depends on NVME_FC && NVME_TARGET_FC
>  	select CRC_T10DIF
>  	help
>            This lpfc driver supports the Emulex LightPulse
>
