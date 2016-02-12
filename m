From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/7] ibmvscsi: Correct values for several
 viosrp_crq_format enums
Date: Fri, 12 Feb 2016 08:29:39 -0600
Message-ID: <56BDEC53.3010400@linux.vnet.ibm.com>
References: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <1455154348-3226-2-git-send-email-tyreld@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:50670 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbcBLO3j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2016 09:29:39 -0500
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Fri, 12 Feb 2016 07:29:39 -0700
In-Reply-To: <1455154348-3226-2-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, jthumshirn@suse.de


Reviewed-by: Manoj Kumar <manoj@linux.vnet.ibm.com>

---
Manoj Kumar

On 2/10/2016 7:32 PM, Tyrel Datwyler wrote:
> The enum values for VIOSRP_LINUX_FORMAT and VIOSRP_INLINE_FORMAT are
> off by one. They are currently defined as 0x06 and 0x07 respetively.
> These values are defined in PAPR correctly as 0x05 and 0x06. This
> inconsistency has gone unnoticed as neither enum is currently used.
> The possible future support of PING messages between the VIOS and
> client adapter relies on VIOSRP_INLINE_FORMAT crq messages.
> Corrected these enum values to match PAPR definitions.
>
> Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>   drivers/scsi/ibmvscsi/viosrp.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/ibmvscsi/viosrp.h b/drivers/scsi/ibmvscsi/viosrp.h
> index 1162430..d1044e9 100644
> --- a/drivers/scsi/ibmvscsi/viosrp.h
> +++ b/drivers/scsi/ibmvscsi/viosrp.h
> @@ -56,8 +56,8 @@ enum viosrp_crq_formats {
>   	VIOSRP_MAD_FORMAT = 0x02,
>   	VIOSRP_OS400_FORMAT = 0x03,
>   	VIOSRP_AIX_FORMAT = 0x04,
> -	VIOSRP_LINUX_FORMAT = 0x06,
> -	VIOSRP_INLINE_FORMAT = 0x07
> +	VIOSRP_LINUX_FORMAT = 0x05,
> +	VIOSRP_INLINE_FORMAT = 0x06
>   };
>
>   enum viosrp_crq_status {
>

