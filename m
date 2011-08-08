From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch] iscsi-target: remove duplicate return
Date: Mon, 08 Aug 2011 13:58:42 -0700
Message-ID: <1312837122.12502.78.camel@haakon2.linux-iscsi.org>
References: <20110806142938.GD10373@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60838 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab1HHVIR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2011 17:08:17 -0400
In-Reply-To: <20110806142938.GD10373@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, kernel-janitors@vger.kernel.org

On Sat, 2011-08-06 at 07:29 -0700, Dan Carpenter wrote:
> We returned on the line before already.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index c24fb10..6a4ea29 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -2243,7 +2243,6 @@ static int iscsit_handle_snack(
>  	case 0:
>  		return iscsit_handle_recovery_datain_or_r2t(conn, buf,
>  			hdr->itt, hdr->ttt, hdr->begrun, hdr->runlength);
> -		return 0;
>  	case ISCSI_FLAG_SNACK_TYPE_STATUS:
>  		return iscsit_handle_status_snack(conn, hdr->itt, hdr->ttt,
>  			hdr->begrun, hdr->runlength);
> --

Thanks Dan, committed as 69b0ec3c38

--nab

