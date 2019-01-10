From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 35/41] scsi: ppa: mark expected switch fall-through
Date: Thu, 10 Jan 2019 13:57:40 -0600
Message-ID: <50080040-1157-49be-b6b3-873f07832bfb@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <ac6de237bf4ee2d748eed7bbc3b2582f54650c0a.1543374820.git.gustavo@embeddedor.com>
 <a83c27d7-28e6-faef-9730-8276aa57b499@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a83c27d7-28e6-faef-9730-8276aa57b499@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Friendly ping (second one):

Who can ack/review/take this patch, please?

Thanks
--
Gustavo

On 12/19/18 6:07 PM, Gustavo A. R. Silva wrote:
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
> On 11/27/18 10:33 PM, Gustavo A. R. Silva wrote:
>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>> where we are expecting to fall through.
>>
>> Addresses-Coverity-ID: 114988 ("Missing break in switch")
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>   drivers/scsi/ppa.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
>> index ee86a0c62dbf..d29999ba5458 100644
>> --- a/drivers/scsi/ppa.c
>> +++ b/drivers/scsi/ppa.c
>> @@ -717,6 +717,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
>>               }
>>               cmd->SCp.phase++;
>>           }
>> +        /* fall through */
>>       case 2:        /* Phase 2 - We are now talking to the scsi bus */
>>           if (!ppa_select(dev, scmd_id(cmd))) {
>>
