From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 06/23] qla2xxx: Update the FTP site references in the
 driver sources.
Date: Mon, 11 Feb 2013 13:49:50 +0100
Message-ID: <5118E8EE.7080807@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:43878 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001Ab3BKMt4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Feb 2013 07:49:56 -0500
Received: by mail-ee0-f42.google.com with SMTP id b47so3097163eek.15
        for <linux-scsi@vger.kernel.org>; Mon, 11 Feb 2013 04:49:55 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

Giridhar Malavali wrote:

> From: Giridhar Malavali <giridhar.malavali@qlogic.com>
> 
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index a581c85..bbf5688 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -5054,7 +5054,7 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
>  	return rval;
>  }
>  
> -#define QLA_FW_URL "ftp://ftp.qlogic.com/outgoing/linux/firmware/"
> +#define QLA_FW_URL "http://ldriver.qlogic.com/firmware/"
>  
>  int
>  qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
> -- 

qla2xxx/Kconfig should also be changed:

       Firmware images can be retrieved from:

                ftp://ftp.qlogic.com/outgoing/linux/firmware/


FYI, they are also included in linux-firmware.
