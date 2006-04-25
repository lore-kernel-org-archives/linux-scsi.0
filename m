From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: aha152x(_cs) oops
Date: Tue, 25 Apr 2006 22:41:28 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0604252143550.3893@poirot.grange>
References: <20060413093615.661b7018.rdunlap@xenotime.net>
 <1144950036.3474.36.camel@mulgrave.il.steeleye.com>
 <20060425115709.0db4332f.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:28105 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751244AbWDYUlm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Apr 2006 16:41:42 -0400
In-Reply-To: <20060425115709.0db4332f.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Tue, 25 Apr 2006, Randy.Dunlap wrote:

> I've spent a lot of time using the sg-PIO patch with the aha152x
> driver.  The sg-PIO part of it works for me, but the aha152x driver
> sometimes does not complete a full DMA-out transfer (data-out phase).
> The driver calls this the need to "resend" some data (in datao_end()).

Sorry, didn't quite understand it - you mean the "in" direction modified 
to use sg-pio works, whereas the "out" doesn't? How exactly it doesn't 
work?

> I can't get this resend logic to work correctly with the sg-PIO
> changes and I can't keep spending time on it without some docs and/or
> errata, so I'll just continue to use my lowmem patch for the
> aha152x driver.

Could you send me / upload your current patch using k(un)map_atomic_pio?

Thanks
Guennadi
---
Guennadi Liakhovetski
