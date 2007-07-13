From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
Date: Fri, 13 Jul 2007 18:35:28 +0200
Message-ID: <20070713163528.GU5328@kernel.dk>
References: <20070704132212.726923000@pademelon.sonytel.be> <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be> <1184335333.3402.20.camel@localhost.localdomain> <200707131619.54898.arnd@arndb.de> <Pine.LNX.4.62.0707131707290.18802@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:21738 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488AbXGMQfp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jul 2007 12:35:45 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0707131707290.18802@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, Paul Mackerras <paulus@samba.org>

On Fri, Jul 13 2007, Geert Uytterhoeven wrote:
> > It's probably a good idea to have the flush_kernel_dcache_page() in there
> > anyway, if only to serve as an example for people that copy it into
> > architecture-independent drivers, same as what we do for the
> > k{,un}map_atomic() that is also not required on ppc64.
> 
> Now my next question: why should I add it, if currently no single driver in
> mainline calls flush_kernel_dcache_page()? 
> 
> `git grep' finds it in the following files only:
>     Documentation/cachetlb.txt
>     arch/parisc/kernel/cache.c
>     arch/parisc/kernel/pacache.S
>     include/asm-parisc/cacheflush.h
>     include/linux/highmem.h

Not many drivers fiddle around with stuff like this, it's usually hidden
behind the dma api or in helpers.

-- 
Jens Axboe

