From: Christoph Hellwig <hch@infradead.org>
Subject: Re: rq_affinity doesn't seem to work?
Date: Fri, 15 Jul 2011 22:40:15 -0400
Message-ID: <20110716024015.GA32253@infradead.org>
References: <D010E79907AF0D4E90B603DE907837D504CA6365D6@azsmsx504.amr.corp.intel.com>
 <4E1CAEEB.8050506@kernel.dk>
 <20110713171011.GA11864@parisc-linux.org>
 <CAL1RGDUDbEG4ypr0GJLLi_0PTjZK0HshMVwTs=aY+=hhFdjK5g@mail.gmail.com>
 <CAHQAjVGK97KU0dB700WSTS1bH0YkW1_MCVaAtjR9aFQRJTcsbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45471
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420Ab1GPCkX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2011 22:40:23 -0400
Content-Disposition: inline
In-Reply-To: <CAHQAjVGK97KU0dB700WSTS1bH0YkW1_MCVaAtjR9aFQRJTcsbA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ersatz splatt <ersatzsplatt@gmail.com>
Cc: Roland Dreier <roland@purestorage.com>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <axboe@kernel.dk>, "Jiang, Dave" <dave.jiang@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Foong, Annie" <annie.foong@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>

On Fri, Jul 15, 2011 at 04:43:44PM -0700, ersatz splatt wrote:
> I have a dual socket system with Tylersburg chipset (approximately
> Westmere I gather).
> With two Xeon X5660 packages I get this when running with more iops
> potential than the system can handle:

What HBA do you use? Does it already have a lockless ->queuecommand?

