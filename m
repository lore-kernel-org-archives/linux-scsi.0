From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Subject: Re: [PATCH] SGIWD93: use cached memory access to make driver work on IP28
Date: Wed, 28 Nov 2007 00:36:57 +0100
Message-ID: <20071127233657.GA32469@alpha.franken.de>
References: <20071126223921.A566CC2B26@solo.franken.de> <Pine.LNX.4.58.0711272348360.407@Indigo2.Peter>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elvis.franken.de ([193.175.24.41]:33038 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186AbXK0XhI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Nov 2007 18:37:08 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0711272348360.407@Indigo2.Peter>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: peter fuerst <post@pfrst.de>
Cc: linux-scsi@vger.kernel.org, linux-mips@linux-mips.org, ralf@linux-mips.org, James.Bottomley@HansenPartnership.com

On Wed, Nov 28, 2007 at 12:00:39AM +0100, peter fuerst wrote:
> unlike with sgiseeq.c, in sgiwd93.c there's no need to bloat the hpc_chunk
> and only a single dma_cache_sync-call is necessary in fill_hpc_entries and
> init_hpc_chain respectively.

funny I realized that a couple of minutes ago. A kernel with this
changes booted ok. I'll post an updated driver tomorrow.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
