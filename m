From: Miroslav Zagorac <zaga@fly.srk.fer.hr>
Subject: Re: [TRIVIAL] [2.5 patch] remove an unused function from wd7000.c
Date: Sat, 6 Sep 2003 08:51:20 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200309060651.h866pKAV001855@fly.srk.fer.hr>
References: <1062670154.21777.3.camel@dhcp23.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fly.srk.fer.hr ([161.53.74.66]:13481 "EHLO fly.srk.fer.hr")
	by vger.kernel.org with ESMTP id S264942AbTIFGvv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Sep 2003 02:51:51 -0400
In-Reply-To: <1062670154.21777.3.camel@dhcp23.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Rusty Trivial Russell <trivial@rustcorp.com.au>, John Boyd <boyd@cis.ohio-state.edu>, Miroslav Zagorac <zaga@fly.cc.fer.hr>, linux-scsi@vger.kernel.org, axboe@suse.de

> On Iau, 2003-09-04 at 08:27, Christoph Hellwig wrote:
> > >   The patch below removes an unused function from drivers/scsi/wd7000.c .
> > >   
> > >   I've tested the compilation with 2.5.72-mm2.
> > 
> > Alan said he wanted to keep this for some reason.  Maybe #if 0 it out?
> 
> Because it needs converting to an eh_abort handler otherwise the card
> will hang if you try and do anything much useful with it.
> 

Hello.  I will make some effort to convert function to eh_abort handler,
very soon.  I'm sorry for late answer and bad english.

-- 
Zaga

Honi soit qui mal y pense.
