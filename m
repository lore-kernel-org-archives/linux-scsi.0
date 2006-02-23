From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Areca RAID driver remaining items?
Date: Thu, 23 Feb 2006 13:07:32 +0100
Message-ID: <1140696452.4672.43.camel@laptopd505.fenrus.org>
References: <1140458552.3495.26.camel@mentorng.gurulabs.com>
	 <20060220182045.GA1634@infradead.org>
	 <001401c63779$12e49aa0$b100a8c0@erich2003>
	 <20060222145733.GC16269@infradead.org>
	 <00dc01c63842$381f9a30$b100a8c0@erich2003>
	 <1140683157.2972.6.camel@laptopd505.fenrus.org>
	 <001901c6385e$9aee7d40$b100a8c0@erich2003>
	 <1140688569.4672.24.camel@laptopd505.fenrus.org>
	 <005a01c6386f$84b30d50$b100a8c0@erich2003>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:3273 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751058AbWBWMHh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Feb 2006 07:07:37 -0500
In-Reply-To: <005a01c6386f$84b30d50$b100a8c0@erich2003>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: erich <erich@areca.com.tw>
Cc: "\"\"Christoph Hellwig\"\"" <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, billion.wu@areca.com.tw, alan@lxorguk.ukuu.org.uk, akpm@osdl.org, oliver@neukum.org

On Thu, 2006-02-23 at 19:51 +0800, erich wrote:
> If Linux can not assurent the contingous memory space allocating of 
> "dma_alloc_coherent" .

coherent memory is guaranteed to be in the "lower" 32 bit of memory!
So that is good news, I think you are just fine.

[Exception is that you can say that you are ok with a bigger mask for
this type of memory, but just don't do that if you're not]


> When arcmsr get a physical ccb address from areca's firmware.
> Does linux has any functions for converting of  "bus to virtual" ?

not without using pools. You would have to search the list of memory you
gave it to find that out.

(USB has a similar problem, afaik they solved it with pools)


