From: peter fuerst <post@pfrst.de>
Subject: Re: [PATCH] WD33C93: let platform stub override no_sync/fast/dma_mode
Date: Fri, 21 Mar 2008 23:28:59 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0803212327070.580@Indigo2.Peter>
References: <20080321212543.6F769C2DF8@solo.franken.de>
 <Pine.LNX.4.58.0803212302190.564@Indigo2.Peter>
Reply-To: post@pfrst.de
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.pearl-online.net ([62.159.194.147]:6042 "EHLO
	mail1.pearl-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844AbYCUWiS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Mar 2008 18:38:18 -0400
In-Reply-To: <Pine.LNX.4.58.0803212302190.564@Indigo2.Peter>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-scsi@vger.kernel.org, linux-mips@linux-mips.org, ralf@linux-mips.org, James.Bottomley@HansenPartnership.com



Oops, forget it, i just missed the change in wd33c93.c, sorry.


kind regrads

peter


On Fri, 21 Mar 2008, peter fuerst wrote:

> Date: Fri, 21 Mar 2008 23:20:07 +0100 (CET)
> From: peter fuerst <post@pfrst.de>
> To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: linux-scsi@vger.kernel.org, linux-mips@linux-mips.org,
>      ralf@linux-mips.org, James.Bottomley@HansenPartnership.com
> Subject: Re: [PATCH] WD33C93: let platform stub override
>     no_sync/fast/dma_mode
>
>
> Hi Thomas,
>
> the code-sequence
> ...
