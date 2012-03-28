From: <Jayamohan.Kallickal@Emulex.Com>
Subject: RE: [PATCH] [SCSI] be2iscsi: Remove unused OFFSET_IN_PAGE() macro
Date: Wed, 28 Mar 2012 14:30:33 -0700
Message-ID: <50725EF61B96174EB1803401F1A2E3733CE646B85C@EXMAIL.ad.emulex.com>
References: <1330584109-4001-1-git-send-email-roland@kernel.org>
 <CAL1RGDX=hd=PX=VD_xjWWau01GcG8Ox_fj-FkMV5Exom_zQ++w@mail.gmail.com>
 <4F71F8D3.3080002@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:57370 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932249Ab2C1Vaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Mar 2012 17:30:55 -0400
In-Reply-To: <4F71F8D3.3080002@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, roland@kernel.org
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org



-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Tuesday, March 27, 2012 10:29 AM
To: Roland Dreier
Cc: Kallickal, Jayamohan; James E.J. Bottomley; linux-scsi@vger.kernel.org
Subject: Re: [PATCH] [SCSI] be2iscsi: Remove unused OFFSET_IN_PAGE() macro

On 03/27/2012 11:38 AM, Roland Dreier wrote:
> On Wed, Feb 29, 2012 at 10:41 PM, Roland Dreier <roland@kernel.org> wrote:
>> From: Roland Dreier <roland@purestorage.com>
>>
>> Signed-off-by: Roland Dreier <roland@purestorage.com>
>> ---
>>  drivers/scsi/be2iscsi/be.h |    4 ----
>>  1 files changed, 0 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h 
>> index 1d7b976..a50b6a9 100644
>> --- a/drivers/scsi/be2iscsi/be.h
>> +++ b/drivers/scsi/be2iscsi/be.h
>> @@ -132,10 +132,6 @@ struct be_ctrl_info {
>>                ((u32)((((size_t)(_address) & (PAGE_SIZE_4K - 1)) +     \
>>                        (size) + (PAGE_SIZE_4K - 1)) >> 
>> PAGE_SHIFT_4K))
>>
>> -/* Byte offset into the page corresponding to given address */
>> -#define OFFSET_IN_PAGE(addr)                                           \
>> -               ((size_t)(addr) & (PAGE_SIZE_4K-1))
>> -
>>  /* Returns bit offset within a DWORD of a bitfield */
>>  #define AMAP_BIT_OFFSET(_struct, field)                                        \
>>                (((size_t)&(((_struct *)0)->field))%32)
> 
> ping?  the corresponding be2net patch is upstream as 97767a87f3be.
> 

Jay probably missed it, because he has been sick. Looks good to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

Thanks Mike for taking care of this 

Acked-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
