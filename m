From: "erich" <erich@areca.com.tw>
Subject: Re: Areca RAID driver remaining items?
Date: Fri, 24 Feb 2006 10:08:22 +0800
Message-ID: <004701c638e7$31d9dc80$b100a8c0@erich2003>
References: <1140458552.3495.26.camel@mentorng.gurulabs.com> <20060220182045.GA1634@infradead.org> <001401c63779$12e49aa0$b100a8c0@erich2003> <20060222145733.GC16269@infradead.org> <00dc01c63842$381f9a30$b100a8c0@erich2003> <1140683157.2972.6.camel@laptopd505.fenrus.org> <001901c6385e$9aee7d40$b100a8c0@erich2003> <1140688569.4672.24.camel@laptopd505.fenrus.org> <005a01c6386f$84b30d50$b100a8c0@erich2003> <1140696452.4672.43.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="big5";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 220-130-178-143.HINET-IP.hinet.net ([220.130.178.143]:58345
	"EHLO areca.com.tw") by vger.kernel.org with ESMTP id S932392AbWBXCIW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Feb 2006 21:08:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: "\"\"\"Christoph Hellwig\"\"\"" <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, billion.wu@areca.com.tw, alan@lxorguk.ukuu.org.uk, akpm@osdl.org, oliver@neukum.org

Dear Arjan van de Ven,

I would keep dma_alloc_coherent usage.

> [Exception is that you can say that you are ok with a bigger mask for
> this type of memory, but just don't do that if you're not]

Should I remove "pci_set_dma_mask(pci_device, DMA_64BIT_MASK)" for this 
case?

Best Regards
Erich Chen

----- Original Message ----- 
From: "Arjan van de Ven" <arjan@infradead.org>
To: "erich" <erich@areca.com.tw>
Cc: """Christoph Hellwig""" <hch@infradead.org>; 
<linux-scsi@vger.kernel.org>; <linux-kernel@vger.kernel.org>; 
<billion.wu@areca.com.tw>; <alan@lxorguk.ukuu.org.uk>; <akpm@osdl.org>; 
<oliver@neukum.org>
Sent: Thursday, February 23, 2006 8:07 PM
Subject: Re: Areca RAID driver remaining items?


> On Thu, 2006-02-23 at 19:51 +0800, erich wrote:
>> If Linux can not assurent the contingous memory space allocating of
>> "dma_alloc_coherent" .
>
> coherent memory is guaranteed to be in the "lower" 32 bit of memory!
> So that is good news, I think you are just fine.
>
> [Exception is that you can say that you are ok with a bigger mask for
> this type of memory, but just don't do that if you're not]
>
>
>> When arcmsr get a physical ccb address from areca's firmware.
>> Does linux has any functions for converting of  "bus to virtual" ?
>
> not without using pools. You would have to search the list of memory you
> gave it to find that out.
>
> (USB has a similar problem, afaik they solved it with pools)
>
> 

