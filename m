From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [2/4] scsi: hpsa: Less function calls in
 hpsa_big_passthru_ioctl() after error detection
Date: Sat, 24 Mar 2018 10:01:07 +0100
Message-ID: <a1e4dcf0-22fa-0b9b-a111-56beac441b24@users.sourceforge.net>
References: <f013341a-e3b2-69a7-4918-8bb3d109f0cc@users.sourceforge.net>
 <e53f792c-0062-1b7a-a914-fa5f62b9a5c9@users.sourceforge.net>
 <1dc030776c924626b97594a18537f59c@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1dc030776c924626b97594a18537f59c@microsemi.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com
Cc: "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>> @@ -6501,14 +6501,16 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info
>> *h, void __user *argp)
>>  cleanup0:
>>         cmd_free(h, c);
>>  cleanup1:
>> -       if (buff) {
>> +       {
>>                 int i;
>>
>>                 for (i = 0; i < sg_used; i++)
>>                         kfree(buff[i]);
>>                 kfree(buff);
>>         }
> 
> Thanks for looking at the hpsa driver.
> 
> This HUNK ends up with an unnamed block.

Which identifier would you like to use there?


> I would prefer to not have it structured like this.

Would you like to show a source code layout alternative?

Regards,
Markus
