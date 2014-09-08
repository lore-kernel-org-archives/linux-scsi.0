From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] bnx2i: Make boot_nic entry visible in the sysfs session
 objects
Date: Mon, 08 Sep 2014 10:02:52 +0200
Message-ID: <540D62AC.3060802@redhat.com>
References: <1400499133-32196-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbaIHID3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Sep 2014 04:03:29 -0400
In-Reply-To: <1400499133-32196-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, Christoph Hellwig <hch@lst.de>
Cc: vikas.chaudhary@qlogic.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, giridhar.malavali@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>

Hi Cristoph, Jens,

On 05/19/2014 01:32 PM, vikas.chaudhary@qlogic.com wrote:
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
> 

Can you merge this patch? It has been ACKed already.

Thanks,
Maurizio Lombardi
