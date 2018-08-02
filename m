From: zhong jiang <zhongjiang@huawei.com>
Subject: Re: [PATCH] scsi:NCR5380: remove same check condition in NCR5380_select
Date: Thu, 2 Aug 2018 11:45:53 +0800
Message-ID: <5B627E71.5020600@huawei.com>
References: <1533179408-20631-1-git-send-email-zhongjiang@huawei.com> <c99a75a2905c1eef50f94ccc0871c36af431e21a.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c99a75a2905c1eef50f94ccc0871c36af431e21a.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "fthain@telegraphics.com.au" <fthain@telegraphics.com.au>, "schmitzmic@gmail.com" <schmitzmic@gmail.com>, "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "john.garry@huawei.com" <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 2018/8/2 11:26, Bart Van Assche wrote:
> On Thu, 2018-08-02 at 11:10 +ACs-0800, zhong jiang wrote:
>> The same check condition is redundant, so remove one of them.
>>
>> Signed-off-by: zhong jiang <zhongjiang+AEA-huawei.com>
>> ---
>>  drivers/scsi/NCR5380.c +AHw- 3 +ACs---
>>  1 file changed, 1 insertion(+ACs-), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
>> index 90ea0f5..2ecaf3f 100644
>> --- a/drivers/scsi/NCR5380.c
>> +ACsAKwAr- b/drivers/scsi/NCR5380.c
>> +AEAAQA- -999,8 +ACs-999,7 +AEAAQA- static struct scsi+AF8-cmnd +ACo-NCR5380+AF8-select(struct Scsi+AF8-Host +ACo-instance,
>>  
>>  	/+ACo- Check for lost arbitration +ACo-/
>>  	if ((NCR5380+AF8-read(INITIATOR+AF8-COMMAND+AF8-REG) +ACY- ICR+AF8-ARBITRATION+AF8-LOST) +AHwAfA-
>> -	    (NCR5380+AF8-read(CURRENT+AF8-SCSI+AF8-DATA+AF8-REG) +ACY- hostdata->id+AF8-higher+AF8-mask) +AHwAfA-
>> -	    (NCR5380+AF8-read(INITIATOR+AF8-COMMAND+AF8-REG) +ACY- ICR+AF8-ARBITRATION+AF8-LOST)) +AHs-
>> +ACs-	    (NCR5380+AF8-read(CURRENT+AF8-SCSI+AF8-DATA+AF8-REG) +ACY- hostdata->id+AF8-higher+AF8-mask)) +AHs-
>>  		NCR5380+AF8-write(MODE+AF8-REG, MR+AF8-BASE);
>>  		dsprintk(NDEBUG+AF8-ARBITRATION, instance, "lost arbitration, deasserting MR+AF8-ARBITRATE+AFw-n");
>>  		spin+AF8-lock+AF8-irq(+ACY-hostdata->lock);
> Has this patch been tested?
 I check the issue by doubletest.cocci. Just review the code by myself. Maybe I miss something else.
 please tell let me know if you any objection.

 Thanks
 zhong jiang
> Thanks,
>
> Bart.
>
>
>
