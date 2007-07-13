From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
Date: Sat, 14 Jul 2007 09:12:08 +1000
Message-ID: <1184368328.6059.271.camel@localhost.localdomain>
References: <20070704132212.726923000@pademelon.sonytel.be>
	 <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be>
	 <1184335333.3402.20.camel@localhost.localdomain>
	 <200707131619.54898.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:50730 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758647AbXGMXMr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jul 2007 19:12:47 -0400
In-Reply-To: <200707131619.54898.arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

On Fri, 2007-07-13 at 16:19 +0200, Arnd Bergmann wrote:
> I'm pretty sure that no ppc64 machine needs alias resolution in the kernel,
> although some are VIPT. Last time we discussed this, Segher explained it
> to me, but I don't remember which way Cell does it. IIRC, it automatically
> flushes cache lines that are accessed through aliases. 

Ah yes, I remember reading about this automatic flushing thing. I don't
know how the caches actually work on most of our PPC's, but the fact is,
we don't have aliasing issues, so I can safely ignore it for a bit
longer :-)

There are some aliasing issues with the instruction cache specifically
on some 4xx models but that's irrelevant to this discussion (and I think
we handle them elsewhere anyway).

Ben.


