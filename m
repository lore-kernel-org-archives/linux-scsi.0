From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 2/3] g_NCR5380: fix broken MMIO compilation
Date: Sun, 20 Dec 2009 22:06:13 +0100
Message-ID: <200912202206.14995.linux@rainbow-software.org>
References: <200912202041.29363.linux@rainbow-software.org> <1261340144.3057.21.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:48494 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754526AbZLTVGZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2009 16:06:25 -0500
In-Reply-To: <1261340144.3057.21.camel@palomino.walls.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Walls <awalls@radix.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sunday 20 December 2009 21:15:44 Andy Walls wrote:
> On Sun, 2009-12-20 at 20:41 +0100, Ondrej Zary wrote:
> > The ifdefs are broken so the MMIO code is never compiled and so it's
> > broken too. Fix them all.
> > Untested as I don't have the hardware.
>
> I still have a DTC-xxxx card in use (under Windows95) and a SUMO SCSI AT
> (usable with g_NCR5380 with a minor hack to toggle a flip flop that
> gates interrupts to the ISA bus).  :)
>
> I think both cards are wired to use I/O space and not memory space, so
> they are of no help for testing MMIO. :(

I have some cards but probably none of them is memory mapped:
DTCT-436P (PnP) - this seems to work (but don't have proper SCSI cable to test 
it really)
HP C2505 (53C400A) - does not work (wrote about this card to LKML in 2004)
Canon FG2-5202 (53C400) - does not work

> But, ah memories....
>
> Regards,
> Andy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Ondrej Zary
