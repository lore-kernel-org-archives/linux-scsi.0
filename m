From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] [SCSI] be2iscsi: Remove unused OFFSET_IN_PAGE() macro
Date: Tue, 27 Mar 2012 12:28:51 -0500
Message-ID: <4F71F8D3.3080002@cs.wisc.edu>
References: <1330584109-4001-1-git-send-email-roland@kernel.org> <CAL1RGDX=hd=PX=VD_xjWWau01GcG8Ox_fj-FkMV5Exom_zQ++w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46311 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab2C0RcV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Mar 2012 13:32:21 -0400
In-Reply-To: <CAL1RGDX=hd=PX=VD_xjWWau01GcG8Ox_fj-FkMV5Exom_zQ++w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

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
>>                        (size) + (PAGE_SIZE_4K - 1)) >> PAGE_SHIFT_4K))
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
