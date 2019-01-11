From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 05/41] scsi: aic7xxx: aic79xx: mark expected switch
 fall-through
Date: Fri, 11 Jan 2019 08:42:23 +0100
Message-ID: <a1c70e7c-5936-a094-7487-8b18318e6257@suse.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <ff0ea78271abe136badebfbeba1d4373fb836bce.1543374820.git.gustavo@embeddedor.com>
 <1d73dbbd-7e8e-e5ba-6a0f-97fdd799d4c4@embeddedor.com>
 <a676a977-c55b-a0ce-1be3-b4d53ec68411@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a676a977-c55b-a0ce-1be3-b4d53ec68411@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 1/10/19 9:15 PM, Gustavo A. R. Silva wrote:
> Hi,
> 
> Friendly ping (second one):
> 
> Who can ack/review/take this patch, please?
> 
> Thanks
> -- 
> Gustavo
> 
> On 12/19/18 9:36 AM, Gustavo A. R. Silva wrote:
>> Hi,
>>
>> Friendly ping:
>>
>> Who can ack or review this patch, please?
>>
>> Thanks
>> -- 
>> Gustavo
>>
>> On 11/27/18 10:26 PM, Gustavo A. R. Silva wrote:
>>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>>> where we are expecting to fall through.
>>>
>>> Notice that, in some cases, I replaced "FALLTHROUGH" with a "fall 
>>> through"
>>> annotation and then placed it at the bottom of the corresponding switch
>>> case, which is what GCC is expecting to find.
>>>
>>> Addresses-Coverity-ID: 114961 ("Missing break in switch")
>>> Addresses-Coverity-ID: 114962 ("Missing break in switch")
>>> Addresses-Coverity-ID: 114963 ("Missing break in switch")
>>> Addresses-Coverity-ID: 114964 ("Missing break in switch")
>>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>>> ---
>>>   drivers/scsi/aic7xxx/aic79xx_core.c | 14 +++++++++-----
>>>   1 file changed, 9 insertions(+), 5 deletions(-)
>>>
Sorry, I thought I'd done so already.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
