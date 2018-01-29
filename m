From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 06/13] lpfc: Add 64G link speed support
Date: Mon, 29 Jan 2018 12:45:47 +0100
Message-ID: <bdaf0bdc-576d-4052-4e63-238d773b26ce@linux.vnet.ibm.com>
References: <20180126193113.29610-1-jsmart2021@gmail.com>
 <20180126193113.29610-7-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34496 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751321AbeA2Lp6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 06:45:58 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0TBjkc4093229
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jan 2018 06:45:58 -0500
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ft0g4xxcf-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jan 2018 06:45:54 -0500
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Mon, 29 Jan 2018 11:45:51 -0000
In-Reply-To: <20180126193113.29610-7-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 01/26/2018 08:31 PM, James Smart wrote:
> The G7 adapter supports 64G link speeds. Add support to the driver.
> 
> In addition, a small cleanup to replace the odd bitmap logic with
> a switch case.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---

>   9 files changed, 92 insertions(+), 30 deletions(-)

> diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
> index d07d2fcbea34..b91b429fe2df 100644
> --- a/drivers/scsi/lpfc/lpfc_hw.h
> +++ b/drivers/scsi/lpfc/lpfc_hw.h

> @@ -2966,6 +2975,9 @@ struct lpfc_mbx_read_top {
>   #define LPFC_LINK_SPEED_10GHZ	0x40
>   #define LPFC_LINK_SPEED_16GHZ	0x80
>   #define LPFC_LINK_SPEED_32GHZ	0x90
> +#define LPFC_LINK_SPEED_64GHZ	0xA0
> +#define LPFC_LINK_SPEED_128GHZ	0xB0
> +#define LPFC_LINK_SPEED_2568GHZ	0xC0
                               ^
typo? 2568 => 256

The new 128 and 256 definitions do not seem to be used in this patch set?

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
