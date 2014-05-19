From: Eddie Wai <eddie.wai@broadcom.com>
Subject: Re: [PATCH] bnx2i: Make boot_nic entry visible in the sysfs
 session objects
Date: Mon, 19 May 2014 09:54:06 -0700
Message-ID: <1400518446.28308.2.camel@lbirv-waie-lx2.broadcom.com>
References: <1400499133-32196-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:17861 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaESQ5x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2014 12:57:53 -0400
In-Reply-To: <1400499133-32196-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, giridhar.malavali@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>

FYI, this was part of the boot_nic sysfs patch which would allow iscsid
to sync_session with info from the iBFT for iSCSI BFS via offload.

This looks good to me.

Acked-by: Eddie Wai <eddie.wai@broadcom.com>

On Mon, 2014-05-19 at 07:32 -0400, vikas.chaudhary@qlogic.com wrote:
> From: Tej Parkash <tej.parkash@qlogic.com>
> 
> Signed-off-by: Tej Parkash <tej.parkash@qlogic.com>
> Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> ---
>  drivers/scsi/bnx2i/bnx2i_iscsi.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index 166543f..cabc8c1 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -2234,6 +2234,9 @@ static umode_t bnx2i_attr_is_visible(int param_type, int param)
>  		case ISCSI_PARAM_TGT_RESET_TMO:
>  		case ISCSI_PARAM_IFACE_NAME:
>  		case ISCSI_PARAM_INITIATOR_NAME:
> +		case ISCSI_PARAM_BOOT_ROOT:
> +		case ISCSI_PARAM_BOOT_NIC:
> +		case ISCSI_PARAM_BOOT_TARGET:
>  			return S_IRUGO;
>  		default:
>  			return 0;


