From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH v2 06/13] lpfc: Add 64G link speed support
Date: Wed, 7 Feb 2018 07:38:39 -0800
Message-ID: <b626516f-3569-59b7-4472-7668f96d0c46@gmail.com>
References: <20180207022851.11800-1-jsmart2021@gmail.com>
 <20180207022851.11800-7-jsmart2021@gmail.com>
 <20180207095846.gkh3oc3k5pnr6mlt@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:40984 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754412AbeBGPin (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2018 10:38:43 -0500
Received: by mail-oi0-f66.google.com with SMTP id m83so952562oik.8
        for <linux-scsi@vger.kernel.org>; Wed, 07 Feb 2018 07:38:42 -0800 (PST)
In-Reply-To: <20180207095846.gkh3oc3k5pnr6mlt@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 2/7/2018 1:58 AM, Johannes Thumshirn wrote:
> On Tue, Feb 06, 2018 at 06:28:44PM -0800, James Smart wrote:
>>   	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
>> -		"0469 lpfc_link_speed attribute cannot be set to %d, "
>> -		"allowed values are ["LPFC_LINK_SPEED_STRING"]\n", val);
>> +			"0469 lpfc_link_speed attribute cannot be set to %d, "
>> +			"allowed values are ["LPFC_LINK_SPEED_STRING"]\n", val);
> 
> 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> 			"0469 lpfc_link_speed attribute cannot be set to %d, "
> 			"allowed values are [%s]\n",
> 			val, LPFC_LINK_SPEED_STRING);
> 
> And possible have the whole quoted string on one line for easier grepping.
> checkplatch.pl should've told you that.
> 

Checkpatch didn't say anything interesting. We consistently have line 
spanning as the lines are fairly verbose. Not an easy way to avoid that.

Regardless, no big deal.

-- james
