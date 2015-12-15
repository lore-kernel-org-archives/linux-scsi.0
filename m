From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH 2/3] hpsa: change SAS transport devices to bus 0.
Date: Tue, 15 Dec 2015 09:25:57 -0600
Message-ID: <56703105.9050109@pmcs.com>
References: <20151209211816.519.50876.stgit@brunhilda>
 <20151209211850.519.87076.stgit@brunhilda>
 <C8F529F3-D668-473E-92D5-5261A147B9E5@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:36529 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbbLOPZ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2015 10:25:59 -0500
Received: by mail-ob0-f176.google.com with SMTP id no2so8947694obc.3
        for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2015 07:25:58 -0800 (PST)
In-Reply-To: <C8F529F3-D668-473E-92D5-5261A147B9E5@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, james.bottomley@parallels.com, linux-scsi@vger.kernel.org

On 12/09/2015 05:21 PM, Matthew R. Ochs wrote:
>> On Dec 9, 2015, at 3:18 PM, Don Brace <don.brace@pmcs.com> wrote:
>>
>> sas transport places devices on bus 0 but driver was setting
>> the bus to 3.
>>
>> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
>> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
>> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
>> Signed-off-by: Don Brace <don.brace@pmcs.com>
>> ---
>> drivers/scsi/hpsa.h |    2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
>> index ae5beda..fdd39fc 100644
>> --- a/drivers/scsi/hpsa.h
>> +++ b/drivers/scsi/hpsa.h
>> @@ -400,7 +400,7 @@ struct offline_device_entry {
>> #define HPSA_PHYSICAL_DEVICE_BUS	0
>> #define HPSA_RAID_VOLUME_BUS		1
>> #define HPSA_EXTERNAL_RAID_VOLUME_BUS	2
>> -#define HPSA_HBA_BUS			3
>> +#define HPSA_HBA_BUS			0
> Is this not the same as using HPSA_PHYSICAL_DEVICE_BUS?
I was just trying to minimize the changes. I can update the driver
is necessary.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

