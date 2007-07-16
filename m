From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
Date: Mon, 16 Jul 2007 14:08:57 +0200
Message-ID: <0A74AFF2-CBDA-4B00-AF5F-B6C6DACE0E16@kernel.crashing.org>
References: <20070704132212.726923000@pademelon.sonytel.be> <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be> <1184335333.3402.20.camel@localhost.localdomain> <200707131619.54898.arnd@arndb.de> <1184368328.6059.271.camel@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:53949 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804AbXGPMJ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 08:09:56 -0400
In-Reply-To: <1184368328.6059.271.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

>> I'm pretty sure that no ppc64 machine needs alias resolution in  
>> the kernel,
>> although some are VIPT. Last time we discussed this, Segher  
>> explained it
>> to me, but I don't remember which way Cell does it. IIRC, it  
>> automatically
>> flushes cache lines that are accessed through aliases.
>
> Ah yes, I remember reading about this automatic flushing thing. I  
> don't
> know how the caches actually work on most of our PPC's, but the  
> fact is,
> we don't have aliasing issues, so I can safely ignore it for a bit
> longer :-)

That is the very short version of the story, yes: some
PowerPC implementations are VIPT physically, but there
are no aliasing issues we have to worry about.

Anyone interested in how this works, can download the
PPC970 UM (or 970FX or 970MP); it has a very detailed
explanation of all this.  Cell might be slightly different
but the base idea is the same.


Segher

