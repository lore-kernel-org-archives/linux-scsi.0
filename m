From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 2/2] arcmsr: code cleanup and some corrections
Date: Fri, 18 Feb 2011 11:59:58 +0100
Message-ID: <4D5E512E.6000904@redhat.com>
References: <4D53F7EF.70003@redhat.com>	<6BCF37FA033449599C8CB43E2D84A0B6@arecaaebe11fae>	<4D5D3941.2090407@redhat.com> <20110218100400A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab1BRLAO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2011 06:00:14 -0500
In-Reply-To: <20110218100400A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: nick.cheng@areca.com.tw, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On 02/18/2011 02:04 AM, FUJITA Tomonori wrote:
> On Thu, 17 Feb 2011 16:05:37 +0100
> Tomas Henzl <thenzl@redhat.com> wrote:
>
>   
>> the discussion is mostly if 'dma_alloc_coherent' 
>> ...
>> dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size, &dma_coherent_handle, GFP_KERNEL);
>> ...
>> returns a page address - dma_coherent with last, I think five bits, zeroed.
>> Could you help us with that?
>>     
> Documentation/DMA-API-HOWTO.txt is not clear enough?
>
> =
> dma_alloc_coherent returns two values: the virtual address which you
> can use to access it from the CPU and dma_handle which you pass to the
> card.
>
> The cpu return address and the DMA bus master address are both
> guaranteed to be aligned to the smallest PAGE_SIZE order which
> is greater than or equal to the requested size.  This invariant
> exists (for example) to guarantee that if you allocate a chunk
> which is smaller than or equal to 64 kilobytes, the extent of the
> buffer you receive will not cross a 64K boundary.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
It's clear enough I think, I asked this question because Nick doesn't
have a "100% confidence in that.". So I wanted a help to convince him.

