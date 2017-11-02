From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: fix CDROM dependency on BLK_DEV
Date: Thu, 2 Nov 2017 09:11:04 -0600
Message-ID: <e11ff1e1-7555-1d8b-2223-bb8d7866a793@kernel.dk>
References: <20171102111952.4021454-1-arnd@arndb.de>
 <212c24f4-7329-f1f5-93c8-090727ed7226@kernel.dk>
 <1509634878.2484.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1509634878.2484.5.camel@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "arnd@arndb.de" <arnd@arndb.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "davem@davemloft.net" <davem@davemloft.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/02/2017 09:01 AM, Bart Van Assche wrote:
> On Thu, 2017-11-02 at 08:27 -0600, Jens Axboe wrote:
>> On 11/02/2017 05:19 AM, Arnd Bergmann wrote:
>>> After the cdrom cleanup, I get randconfig warnings for some configurations:
>>>
>>> warning: (BLK_DEV_IDECD && BLK_DEV_SR) selects CDROM which has unmet direct dependencies (BLK_DEV)
>>>
>>> This adds an explicit BLK_DEV dependency for both drivers. The other
>>> drivers that select 'CDROM' already have this and don't need a change.
>>
>> Thanks Arnd, applied.
> 
> Hello Jens,
> 
> Can you wait at least 24 hours after a patch has been posted before applying it
> such those who want to post review comments have a chance to do that?

I generally at least do that, unless they are trivial...


-- 
Jens Axboe
