From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 39/41] scsi: sym53c8xx_2: sym_nvram: Mark expected switch
 fall-through
Date: Thu, 10 Jan 2019 13:54:54 -0600
Message-ID: <5e6a37a4-d05b-de9f-3f4f-c7561d730071@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <5e410e73a46bb5722617d4060bd5d92ca5be34bd.1543374820.git.gustavo@embeddedor.com>
 <c2ae15f3-63a6-26df-179f-99f76c827ef8@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c2ae15f3-63a6-26df-179f-99f76c827ef8@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Friendly ping (second one):

Who can ack/review/take this patch, please?

Thanks
--
Gustavo

On 12/19/18 6:08 PM, Gustavo A. R. Silva wrote:
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
> On 11/27/18 10:34 PM, Gustavo A. R. Silva wrote:
>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>> where we are expecting to fall through.
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>   drivers/scsi/sym53c8xx_2/sym_nvram.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/sym53c8xx_2/sym_nvram.c b/drivers/scsi/sym53c8xx_2/sym_nvram.c
>> index 5662fbb3ff60..0d37b4f07b5e 100644
>> --- a/drivers/scsi/sym53c8xx_2/sym_nvram.c
>> +++ b/drivers/scsi/sym53c8xx_2/sym_nvram.c
>> @@ -708,6 +708,7 @@ static int sym_read_Tekram_nvram (struct sym_device *np, Tekram_nvram *nvram)
>>                         data, len);
>>           if (!x)
>>               break;
>> +        /* fall through */
>>       default:
>>           x = sym_read_T93C46_nvram(np, nvram);
>>           break;
>>
