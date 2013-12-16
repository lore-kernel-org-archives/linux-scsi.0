From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 25/32] target: Call remove_lun instead of del_lun in
 fabric_port_unlink
Date: Mon, 16 Dec 2013 13:47:06 -0800
Message-ID: <1387230426.20247.245.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-26-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:46583 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3LPVqN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 16:46:13 -0500
In-Reply-To: <1386979160-6928-26-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:59 -0800, Andy Grover wrote:
> We want to be freeing the port here, not freeing the lun.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_fabric_configfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 

Skipping this one as well.

--nab

> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> index 4715836..fe940d4 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -808,7 +808,7 @@ static int target_fabric_port_unlink(
>  		tf->tf_ops.fabric_pre_unlink(se_tpg, lun);
>  	}
>  
> -	core_dev_del_lun(se_tpg, lun);
> +	core_tpg_remove_lun(se_tpg, lun);
>  	return 0;
>  }
>  


