From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: use MAINTENANCE_IN and MAINTENANCE_OUT
	definitions in scsi.h
Date: Mon, 21 Feb 2011 01:18:43 -0800
Message-ID: <1298279923.26616.62.camel@haakon2.linux-iscsi.org>
References: <20110215145315U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:42721 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab1BUKBU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Feb 2011 05:01:20 -0500
In-Reply-To: <20110215145315U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Tue, 2011-02-15 at 14:53 +0900, FUJITA Tomonori wrote:
> What branch am I supposed to send a patch for the next release (that
> is, will go to scsi-misc)?
> 
> lio-core-2.6.git/master, right?
> 

Hi Tomo-san

Thanks for your patch, and my apologies for the delayed response on this
from last week..  This change been pushed into
lio-core-2.6.git/linus-38-rc5 and master branches.

Patches against either of these tracking branches works fine for me.

Best Regards,

--nab

> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] target: use MAINTENANCE_IN and MAINTENANCE_OUT definitions in scsi.h
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/target/target_core_transport.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 123bd94..4184b0d 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -3314,7 +3314,7 @@ static int transport_generic_cmd_sequencer(
>  			goto out_unsupported_cdb;
>  		}
>  		break;
> -	case 0xa3:
> +	case MAINTENANCE_IN:
>  		if (TRANSPORT(dev)->get_device_type(dev) != TYPE_ROM) {
>  			/* MAINTENANCE_IN from SCC-2 */
>  			/*
> @@ -3384,7 +3384,7 @@ static int transport_generic_cmd_sequencer(
>  		size = READ_POSITION_LEN;
>  		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
> -	case 0xa4:
> +	case MAINTENANCE_OUT:
>  		if (TRANSPORT(dev)->get_device_type(dev) != TYPE_ROM) {
>  			/* MAINTENANCE_OUT from SCC-2
>  			 *

