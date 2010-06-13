From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 10/15] iscsi_transport: added new iscsi_param to display
 target alias is sysfs
Date: Sun, 13 Jun 2010 14:33:59 -0500
Message-ID: <4C1532A7.2090505@cs.wisc.edu>
References: <20100611074754.GA27798@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42082 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab0FMTbo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jun 2010 15:31:44 -0400
In-Reply-To: <20100611074754.GA27798@sles11sp1b1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: james.bottomley@suse.de, linux-scsi@vger.kernel.org, ravi.anand@qlogic.com

On 06/11/2010 02:47 AM, Vikas Chaudhary wrote:
> index 66d377b..2990ca8 100644
> --- a/include/scsi/iscsi_if.h
> +++ b/include/scsi/iscsi_if.h
> @@ -286,6 +286,7 @@ enum iscsi_param {
>   	ISCSI_PARAM_OFMARKER_EN,
>   	ISCSI_PARAM_EXP_STATSN,
>   	ISCSI_PARAM_TARGET_NAME,
> +	ISCSI_PARAM_TARGET_ALIAS,

You have to add your value after ISCSI_PARAM_TGT_RESET_TMO, because 
userspace uses the same values and older tools would get screwed up.
