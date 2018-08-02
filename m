From: zhong jiang <zhongjiang@huawei.com>
Subject: Re: [PATCH 2/2] scsi:qlogicfas408: remove the same check in qlogicfas408_detect
Date: Thu, 2 Aug 2018 11:29:54 +0800
Message-ID: <5B627AB2.8000101@huawei.com>
References: <1533177901-19514-1-git-send-email-zhongjiang@huawei.com>  <1533177901-19514-3-git-send-email-zhongjiang@huawei.com> <dc1f8e81007466172d383cc63a4be246c568a2d4.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <dc1f8e81007466172d383cc63a4be246c568a2d4.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>, "aacraid@microsemi.com" <aacraid@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2018/8/2 11:21, Bart Van Assche wrote:
> On Thu, 2018-08-02 at 10:45 +ACs-0800, zhong jiang wrote:
>> we should not use same check in a expression. just remove one
>> of them.
>>
>> Signed-off-by: zhong jiang <zhongjiang+AEA-huawei.com>
>> ---
>>  drivers/scsi/qlogicfas408.c +AHw- 3 +ACs---
>>  1 file changed, 1 insertion(+ACs-), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
>> index 8b471a9..1409ac1 100644
>> --- a/drivers/scsi/qlogicfas408.c
>> +ACsAKwAr- b/drivers/scsi/qlogicfas408.c
>> +AEAAQA- -567,8 +ACs-567,7 +AEAAQA- void qlogicfas408+AF8-setup(int qbase, int id, int int+AF8-type)
>>  int qlogicfas408+AF8-detect(int qbase, int int+AF8-type)
>>  +AHs-
>>          REG1;
>> -	return (((inb(qbase +ACs- 0xe) +AF4- inb(qbase +ACs- 0xe)) == 7) +ACYAJg-
>> -	       ((inb(qbase +ACs- 0xe) +AF4- inb(qbase +ACs- 0xe)) == 7));		
>> +ACs-	return (inb(qbase +ACs- 0xe) +AF4- inb(qbase +ACs- 0xe)) == 7;
>>  +AH0-
> Does inb() have any side effects?
 just redundant. is it necessary for this . Maybe I miss something.

 Thanks,
 zhong jiang
> Bart.
>
>
>
