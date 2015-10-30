From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH 1 08/25] hpsa: fix hpsa_adjust_hpsa_scsi_table
Date: Fri, 30 Oct 2015 15:46:45 -0500
Message-ID: <5633D735.1000000@pmcs.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220518.5323.5177.stgit@brunhilda> <563322DE.3010007@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f196.google.com ([209.85.214.196]:34431 "EHLO
	mail-ob0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbbJ3Uqq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 16:46:46 -0400
Received: by obbza9 with SMTP id za9so4312109obb.1
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 13:46:46 -0700 (PDT)
In-Reply-To: <563322DE.3010007@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org



On 10/30/2015 02:57 AM, Hannes Reinecke wrote:
> On 10/28/2015 11:05 PM, Don Brace wrote:
>> Fix a NULL pointer issue in the driver when devices are removed
>> during a reset.
>>
>> Signed-off-by: Don Brace <don.brace@pmcs.com>
>> ---
>>   drivers/block/cciss.h |    1 +
>>   drivers/scsi/hpsa.c   |   16 ++++++++++++++++
>>   drivers/scsi/hpsa.h   |    1 +
>>   3 files changed, 18 insertions(+)
>>
>> diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
>> index 7fda30e..f8b8c6b 100644
>> --- a/drivers/block/cciss.h
>> +++ b/drivers/block/cciss.h
>> @@ -155,6 +155,7 @@ struct ctlr_info
>>   	size_t reply_pool_size;
>>   	unsigned char reply_pool_wraparound;
>>   	u32 *blockFetchTable;
>> +	u8 reset_in_progress;
>>   };
>>   
>>   /*  Defining the diffent access_methods
> Why do you need to add it here?
> To my knowledge cciss and hpsa are different drivers ...
ctag issue. corrected.
>
> Cheers,
>
> Hannes

