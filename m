From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Patch submission question [not in the FAQ]
Date: Sun, 9 Dec 2007 13:57:12 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712091356530.31899@anakin>
References: <602863.12913.qm@web53712.mail.re2.yahoo.com>
 <b1bc6a000712061337o189b96bal45c0b7b5b7d47568@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from asia.telenet-ops.be ([195.130.137.74]:56980 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbXLIM5T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Dec 2007 07:57:19 -0500
In-Reply-To: <b1bc6a000712061337o189b96bal45c0b7b5b7d47568@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: Gabriele Gorla <gorlik@yahoo.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 6 Dec 2007, adam radford wrote:
> 2. I removed the bitfields from the 3w-xxxx driver but I have
>    yet to add full big endian support due to lack of demand.  I have
>    such a patch for this driver (which already includes the unpacking
>    of the wait_queue_head_t variable) but I have not submitted it to
>    the main-line kernel.  The in-kernel 3w-xxxx driver is still missing
>    the byte-swaps.
> 
>    The 3w-9xxx (9000 series 3ware driver) has full big endian support.
> 
> Is this an official request for big endian support for the 3w-xxxx driver or
> are you looking for anybody who has a packed 'wait_queue_head_t' and
> submitting a patch to fix it?

Alpha is little endian.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
