From: Matthew Jacob <mjacob@feral.com>
Subject: Re: Feral Qlogic ISP driver up for testing
Date: Thu, 15 May 2003 10:23:44 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030515102158.A12807@wonky.in0.lcl>
References: <1053017923.2267.76.camel@mulgrave>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from beppo.feral.com ([192.67.166.79]:9992 "EHLO beppo.feral.com")
	by vger.kernel.org with ESMTP id S264121AbTEORLY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2003 13:11:24 -0400
In-Reply-To: <1053017923.2267.76.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@digeo.com>


Oi! Oi! That was a bit quicker than I was ready for! Please send me bug
reports and I'll take a child off of this to do my updates.

If it's all the same to you, I'd like to make 2.5 a cleaned out branch
separate from the 2.4 and earlier branches so it can be a lot cleaner.


On Thu, 15 May 2003, James Bottomley wrote:

> I've taken Matthew Jacob's latest drop of the Feral ISP driver and put
> it up under bitkeeper at
>
> http://linux-scsi.bkbits.net/scsi-isp-2.5
>
> I've plumbed it into the SCSI build and done some minor tweaking to make
> it compile and run correctly in 2.5 (a missing vmalloc #include and the
> irqreturn_t stuff).
>
> If people could check it out, I'd be grateful.
>
> I find on my 1280 board that it panics in isp_reset(), but that could
> just be because I use exotic hardware (a PA-RISC C360 box) for testing.
>
> James
>
>
>
