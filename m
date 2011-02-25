From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: RE: [PATCH 2/2] arcmsr: code cleanup and some corrections
Date: Fri, 25 Feb 2011 09:30:09 +0800
Message-ID: <3AB9F6E85D8B42CAB0FD94675FBE0044@arecaaebe11fae>
References: <4D53F7EF.70003@redhat.com>	<6BCF37FA033449599C8CB43E2D84A0B6@arecaaebe11fae>	<4D5D3941.2090407@redhat.com> <20110218100400A.fujita.tomonori@lab.ntt.co.jp> <4D5E512E.6000904@redhat.com> <4D6667E3.7030909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59753 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214Ab1BYBb5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2011 20:31:57 -0500
Received: by ewy6 with SMTP id 6so446995ewy.19
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2011 17:31:56 -0800 (PST)
In-Reply-To: <4D6667E3.7030909@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Tomas Henzl' <thenzl@redhat.com>, 'FUJITA Tomonori' <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

Acked-by: Nick Cheng<nick.cheng@areca.com.tw>
-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com] 
Sent: Thursday, February 24, 2011 10:15 PM
To: FUJITA Tomonori
Cc: nick.cheng@areca.com.tw; linux-scsi@vger.kernel.org;
James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH 2/2] arcmsr: code cleanup and some corrections

Hi Nick,
again thanks for your response in the 
'arcmsr: code cleanup and some corrections' thread.

Let us find a resolution here too.
Is the original patch fine for you, or do you prefer not to take it?

Tomas


> On 02/18/2011 02:04 AM, FUJITA Tomonori wrote:
>   
>> On Thu, 17 Feb 2011 16:05:37 +0100
>> Tomas Henzl <thenzl@redhat.com> wrote:
>>
>>   
>>     
>>> the discussion is mostly if 'dma_alloc_coherent' 
>>> ...
>>> dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size,
&dma_coherent_handle, GFP_KERNEL);
>>> ...
>>> returns a page address - dma_coherent with last, I think five bits,
zeroed.
>>> Could you help us with that?
>>>     
>>>       
>> Documentation/DMA-API-HOWTO.txt is not clear enough?
>>
>> =
>> dma_alloc_coherent returns two values: the virtual address which you
>> can use to access it from the CPU and dma_handle which you pass to the
>> card.
>>
>> The cpu return address and the DMA bus master address are both
>> guaranteed to be aligned to the smallest PAGE_SIZE order which
>> is greater than or equal to the requested size.  This invariant
>> exists (for example) to guarantee that if you allocate a chunk
>> which is smaller than or equal to 64 kilobytes, the extent of the
>> buffer you receive will not cross a 64K boundary.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>   
>>     
> It's clear enough I think, I asked this question because Nick doesn't
> have a "100% confidence in that.". So I wanted a help to convince him.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

