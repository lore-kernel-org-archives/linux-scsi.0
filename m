From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 32/41] scsi: myrb: Mark expected switch fall-throughs
Date: Thu, 20 Dec 2018 07:49:26 +0100
Message-ID: <e27c10d5-9724-1a7d-d388-50e22606f4d6@suse.de>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <15cf75b544d6b2eae77ba98cd201620b44abec36.1543374820.git.gustavo@embeddedor.com>
 <025dd9a3-e2a0-cb21-8458-f671a673f634@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <025dd9a3-e2a0-cb21-8458-f671a673f634@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Hannes Reinecke <hare@kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/20/18 1:07 AM, Gustavo A. R. Silva wrote:
> Hi,
> 
> Friendly ping:
> 
> Who can ack or review this patch, please?
> 
> Thanks
> -- 
> Gustavo
> 
> On 11/27/18 10:32 PM, Gustavo A. R. Silva wrote:
>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>> where we are expecting to fall through.
>>
>> Addresses-Coverity-ID: 1465234 ("Missing break in switch")
>> Addresses-Coverity-ID: 1465238 ("Missing break in switch")
>> Addresses-Coverity-ID: 1465242 ("Missing break in switch")
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>   drivers/scsi/myrb.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
