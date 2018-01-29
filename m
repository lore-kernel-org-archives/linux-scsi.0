From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 06/13] lpfc: Add 64G link speed support
Date: Mon, 29 Jan 2018 10:32:58 -0800
Message-ID: <7efadbc3-60dc-b134-26ff-d4d89421488c@broadcom.com>
References: <20180126193113.29610-1-jsmart2021@gmail.com>
 <20180126193113.29610-7-jsmart2021@gmail.com>
 <bdaf0bdc-576d-4052-4e63-238d773b26ce@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:46998 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751249AbeA2SdB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2018 13:33:01 -0500
Received: by mail-qk0-f174.google.com with SMTP id l64so6803981qke.13
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jan 2018 10:33:01 -0800 (PST)
In-Reply-To: <bdaf0bdc-576d-4052-4e63-238d773b26ce@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>

On 1/29/2018 3:45 AM, Steffen Maier wrote:
> @@ -2966,6 +2975,9 @@ struct lpfc_mbx_read_top {
>>   #define LPFC_LINK_SPEED_10GHZ    0x40
>>   #define LPFC_LINK_SPEED_16GHZ    0x80
>>   #define LPFC_LINK_SPEED_32GHZ    0x90
>> +#define LPFC_LINK_SPEED_64GHZ    0xA0
>> +#define LPFC_LINK_SPEED_128GHZ    0xB0
>> +#define LPFC_LINK_SPEED_2568GHZ    0xC0
>                               ^
> typo? 2568 => 256
>
> The new 128 and 256 definitions do not seem to be used in this patch set?
>

Yep. And not used yet.  I'll fix in a repost.  For the repost, I'll wait 
until the other patches have a review.

-- james
