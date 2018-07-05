From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 1/4] scsi: aacraid: remove AAC_STAT_GOOD define
Date: Thu, 5 Jul 2018 10:49:16 -0700
Message-ID: <e0a3470a-6e52-5585-602e-0e515194b26d@gmail.com>
References: <20180705110140.19545-1-jthumshirn@suse.de>
 <20180705110140.19545-2-jthumshirn@suse.de>
 <4cd9a8cb64dc4d8aa1e10c3b008c3ba0@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4cd9a8cb64dc4d8aa1e10c3b008c3ba0@microsemi.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Carroll <david.carroll@microsemi.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
List-Id: linux-scsi@vger.kernel.org

On 07/05/18 10:42, Dave Carroll wrote:
>> Remove the AAC_STAT_GOOD definition and open code it in the places it was
>> used.
>>
>> This will make subsequent refactoring in this area easier.
>>
> Please don't ... the definition itself was added to make refactoring easier.

That's a vague statement. Which kind of refactoring do you plan to make?

Bart.
