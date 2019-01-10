From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 14/41] scsi: esas2r: esas2r_init: mark expected switch
 fall-throughs
Date: Thu, 10 Jan 2019 14:08:56 -0600
Message-ID: <3751e0eb-e57b-9aed-c23a-f593b780605b@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <eb98d6f510cd93e45d7832837acd4e5811f3d20e.1543374820.git.gustavo@embeddedor.com>
 <b7f0fbf6-a793-c22c-cc3e-e35706d722f9@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b7f0fbf6-a793-c22c-cc3e-e35706d722f9@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bradley Grove <linuxdrivers@attotech.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Friendly ping (second one):

Who can ack/review/take this patch, please?

Thanks
--
Gustavo

On 12/19/18 9:39 AM, Gustavo A. R. Silva wrote:
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
> On 11/27/18 10:28 PM, Gustavo A. R. Silva wrote:
>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>> where we are expecting to fall through.
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>   drivers/scsi/esas2r/esas2r_init.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
>> index 46b2c83ba21f..950cd92df2ff 100644
>> --- a/drivers/scsi/esas2r/esas2r_init.c
>> +++ b/drivers/scsi/esas2r/esas2r_init.c
>> @@ -1241,6 +1241,7 @@ static bool esas2r_format_init_msg(struct esas2r_adapter *a,
>>               a->init_msg = ESAS2R_INIT_MSG_GET_INIT;
>>               break;
>>           }
>> +        /* fall through */
>>       case ESAS2R_INIT_MSG_GET_INIT:
>>           if (msg == ESAS2R_INIT_MSG_GET_INIT) {
>> @@ -1254,7 +1255,7 @@ static bool esas2r_format_init_msg(struct esas2r_adapter *a,
>>                   esas2r_hdebug("FAILED");
>>               }
>>           }
>> -    /* fall through */
>> +        /* fall through */
>>       default:
>>           rq->req_stat = RS_SUCCESS;
>>
