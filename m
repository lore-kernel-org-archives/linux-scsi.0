From: Jeremy Cline <jeremy@jcline.org>
Subject: Re: [PATCH] scsi: sd: Keep disk read-only when re-reading partition
Date: Fri, 2 Mar 2018 14:11:02 +0000
Message-ID: <01000161e70d459d-67080961-ba28-43ff-b519-2432ce5313f7-000000@email.amazonses.com>
References: <01000161e1e448a5-d54e05d2-58f2-4480-b05b-67185d4ffae7-000000@email.amazonses.com>
 <20180302120038.4mgcn2lmft4ygqz4@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180302120038.4mgcn2lmft4ygqz4@linux-x5ow.site>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/02/2018 07:00 AM, Johannes Thumshirn wrote:
> On Thu, Mar 01, 2018 at 02:08:10PM +0000, Jeremy Cline wrote:
>> If the read-only flag is true on a SCSI disk, re-reading the partition
>> table sets the flag back to false.
>>
>> To observe this bug, you can run:
>>
>> 1. blockdev --setro /dev/sda
>> 2. blockdev --rereadpt /dev/sda
>> 3. blockdev --getro /dev/sda
> 
> hi Jeremy,
> 
> Do you mind wiring up a testcase in blktest [1] for this? Given that
> you already have a rather trivial reproducer.
> 
> [1] https://github.com/osandov/

Hi Johannes,

Sure, I'll take care of it.

Regards,
Jeremy
