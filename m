From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH 06/17] lpfc: NVME Initiator: Base modifications Part E
Date: Wed, 18 Jan 2017 18:14:35 -0800
Message-ID: <cc0b019e-19e9-dfaa-314d-98a8545e7542@gmail.com>
References: <587ec2f1.pGgoAJWGU6FWMEv6%jsmart2021@gmail.com>
 <cefa5f07-a3f3-c5dc-2d3a-ddd410d1ffa4@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:34734 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751741AbdASCXc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2017 21:23:32 -0500
Received: by mail-ot0-f196.google.com with SMTP id 73so2957746otj.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2017 18:23:08 -0800 (PST)
In-Reply-To: <cefa5f07-a3f3-c5dc-2d3a-ddd410d1ffa4@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org



On 1/17/2017 11:34 PM, Hannes Reinecke wrote:
> Is this ever reset?
> I don't see it here ...

the lpfc_sli4_hba_setup(), which resets the function and reinits, clears 
the flag.

>
> [ .. ]
>> @@ -4380,9 +4469,12 @@ lpfc_sli_chipset_init(struct lpfc_hba *phba)
>>    * configured.
>>    **/
>>   int
>> -lpfc_sli_hbq_count(void)
>> +lpfc_sli_hbq_count(struct lpfc_hba *phba)
>>   {
>> -	return ARRAY_SIZE(lpfc_hbq_defs);
>> +	int i;
>> +
>> +	i = ARRAY_SIZE(lpfc_hbq_defs);
>> +	return i;
>>   }
>>   
>>   /**
> The point of this change being ...?

I don't know - will collapse it.

-- james


