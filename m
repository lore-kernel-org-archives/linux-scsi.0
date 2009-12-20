From: Andy Walls <awalls@radix.net>
Subject: Re: [PATCH 2/3] g_NCR5380: fix broken MMIO compilation
Date: Sun, 20 Dec 2009 15:15:44 -0500
Message-ID: <1261340144.3057.21.camel@palomino.walls.org>
References: <200912202041.29363.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:49237 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbZLTUQb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Dec 2009 15:16:31 -0500
In-Reply-To: <200912202041.29363.linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 20:41 +0100, Ondrej Zary wrote:
> The ifdefs are broken so the MMIO code is never compiled and so it's broken
> too. Fix them all.
> Untested as I don't have the hardware.

I still have a DTC-xxxx card in use (under Windows95) and a SUMO SCSI AT
(usable with g_NCR5380 with a minor hack to toggle a flip flop that
gates interrupts to the ISA bus).  :)

I think both cards are wired to use I/O space and not memory space, so
they are of no help for testing MMIO. :(  

But, ah memories....

Regards,
Andy

