From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] scsi: add Mylex RAID controller
Date: Wed, 9 Aug 2017 17:11:02 +0200
Message-ID: <e2bbe433-3368-916c-1e88-07eabd9876e7@suse.de>
References: <1501683208-5240-1-git-send-email-hare@suse.de>
 <1501683208-5240-4-git-send-email-hare@suse.de>
 <20170805113932.GF16313@lst.de>
 <17589cb4-9f0c-7d15-8c3a-79bd9b14fdef@suse.de>
 <20170809141049.GB26843@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170809141049.GB26843@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jth@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 08/09/2017 04:10 PM, Christoph Hellwig wrote:
> On Mon, Aug 07, 2017 at 08:09:11AM +0200, Hannes Reinecke wrote:
>> On 08/05/2017 01:39 PM, Christoph Hellwig wrote:
>>> Can you use normal linux style for the code instead of copy and
>>> pasting the weird naming and capitalization from the DAC960 driver?
>>>
>> Yes; already planned for v2. But first wanted to get some general
>> feedback (like: is anyone interested in that at all?)
> 
> Yes, please go ahead and kill off the DAC960 driver.
> 
I knew you would be saying that :-)

>>
>>> Also please use the driver name as prefix for the functions.
>>>
>> Ok.
>>
>>> Maybe myraid instead of mylex?
>>>
>> Nah; I'd rather stick with mylex.
>> (Especially as it says 'Mylex' in big fat letters on the board :-)
> 
> Naming drivers after the vendor only is usually a bad idea as vendors
> have/had multiple products.  In this case we have plenty other drivers
> that support Mylex products.
> 
Okay. Make it 'myraid_pio' and 'myraid_mmio' then.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
