From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 07/41] scsi: be2iscsi: be_iscsi: Mark expected switch
 fall-through
Date: Thu, 10 Jan 2019 14:13:08 -0600
Message-ID: <1b24ffa5-0553-b295-378b-1fed2b2c5dca@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <4da131a74bf4d88c49307ade507b48aee86b4714.1543374820.git.gustavo@embeddedor.com>
 <bc99a534-bc6c-d093-eca2-a085bd1dfd82@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bc99a534-bc6c-d093-eca2-a085bd1dfd82@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Subbu Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Friendly ping (second one):

Who can ack/review/take this patch, please?

Thanks
--
Gustavo

On 12/19/18 9:37 AM, Gustavo A. R. Silva wrote:
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
> On 11/27/18 10:26 PM, Gustavo A. R. Silva wrote:
>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>> where we are expecting to fall through.
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>   drivers/scsi/be2iscsi/be_iscsi.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
>> index 96b96e2ab91a..ed1bd369baa0 100644
>> --- a/drivers/scsi/be2iscsi/be_iscsi.c
>> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
>> @@ -679,6 +679,7 @@ int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
>>       case ISCSI_PARAM_MAX_XMIT_DLENGTH:
>>           if (conn->max_xmit_dlength > 65536)
>>               conn->max_xmit_dlength = 65536;
>> +        /* fall through */
>>       default:
>>           return 0;
>>       }
>>
