From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] LIBISCSI: Added new boot entries in the session sysfs
Date: Thu, 20 Jun 2013 10:57:02 -0500
Message-ID: <51C3264E.7080802@cs.wisc.edu>
References: <Eddie Wai> <1370889281-22597-1-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52249 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756318Ab3FTP5P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jun 2013 11:57:15 -0400
In-Reply-To: <1370889281-22597-1-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Eddie Wai <eddie.wai@broadcom.com>, James Bottomley <jbottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>

On 06/10/2013 01:34 PM, Eddie Wai wrote:
> index fe7f06c..f9cc89b 100644
> --- a/include/scsi/iscsi_if.h
> +++ b/include/scsi/iscsi_if.h
> @@ -487,6 +487,10 @@ enum iscsi_param {
>  	ISCSI_PARAM_TGT_RESET_TMO,
>  	ISCSI_PARAM_TARGET_ALIAS,
>  
> +	ISCSI_PARAM_BOOT_ROOT,
> +	ISCSI_PARAM_BOOT_NIC,
> +	ISCSI_PARAM_BOOT_TARGET,
> +
>  	ISCSI_PARAM_CHAP_IN_IDX,
>  	ISCSI_PARAM_CHAP_OUT_IDX,
>  	/* must always be last */

We cannot add in the middle because it would screw up older tools and
kernels. Just add adter the CHAP ones at the end.

Other than that patch looks ok.
