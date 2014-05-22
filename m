From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] bnx2i: Make boot_nic entry visible in the sysfs session
 objects
Date: Thu, 22 May 2014 12:29:03 -0500
Message-ID: <537E33DF.30808@cs.wisc.edu>
References: <1400499133-32196-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39117 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbaEVR3V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 May 2014 13:29:21 -0400
In-Reply-To: <1400499133-32196-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, giridhar.malavali@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>

On 05/19/2014 06:32 AM, vikas.chaudhary@qlogic.com wrote:
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

I think we also wanted this for the chelsio driver, but I need to set it
up to test. So for now, looks ok to me. If chelsio needs it, I can send
a patch for that when done testing.


Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

