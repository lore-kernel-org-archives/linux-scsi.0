From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 6/8] scsi/ipr: Use sgl_alloc_order() and
 sgl_free_order()
Date: Wed, 1 Nov 2017 12:13:48 +0100
Message-ID: <a3274a4a-e0aa-0081-dfa1-e3c884800133@suse.de>
References: <20171016224940.1332-1-bart.vanassche@wdc.com>
 <20171016224940.1332-7-bart.vanassche@wdc.com>
 <c804098f-5543-395c-1395-5778ef74a61b@suse.de>
 <ce6f2f5b-b4bc-380f-8ac1-1e91e4d6bf24@linux.vnet.ibm.com>
 <1509395828.27259.21.camel@wdc.com>
 <33515fd2-9639-7981-e344-80cdacd40d32@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40239 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751669AbdKALNv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Nov 2017 07:13:51 -0400
In-Reply-To: <33515fd2-9639-7981-e344-80cdacd40d32@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On 10/30/2017 10:01 PM, Brian King wrote:
> On 10/30/2017 03:37 PM, Bart Van Assche wrote:
>> On Wed, 2017-10-18 at 15:57 -0500, Brian King wrote:
>>> On 10/17/2017 01:19 AM, Hannes Reinecke wrote:
>>>> On 10/17/2017 12:49 AM, Bart Van Assche wrote:
>>>>> [ ... ]
>>>>
>>>> Not sure if this is a valid conversion.
>>>> Originally the driver would allocate a single buffer; with this buffer
>>>> we have two distinct buffers.
>>>> Given that this is used to download the microcode I'm not sure if this
>>>> isn't a hardware-dependent structure which requires a single buffer
>>>> including the sglist.
>>>> Brian, can you shed some light here?
>>>
>>> The struct ipr_sglist is not a hardware defined data structure, so on initial
>>> glance, this should be OK. I'll load it up and give it a try to make sure
>>> it doesn't break code download.
>>
>> Hello Brian,
>>
>> Have you already obtained any test results?
> 
> Bart,
> 
> Yes. I tried this out on an ipr adapter and it looks fine.
> 
> Acked-by: Brian King <brking@linux.vnet.ibm.com>
> 
Thanks for the confirmation.

Bart, you can add my

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
