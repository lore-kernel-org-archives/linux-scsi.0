From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: aic79xx hang at boot
Date: Fri, 19 Nov 2004 08:27:02 -0500
Message-ID: <419DF4A6.3030801@adaptec.com>
References: <1100858328.2689.36.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:58000 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261400AbUKSN1Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 08:27:24 -0500
In-Reply-To: <1100858328.2689.36.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrea.carpani@criticalpath.net
Cc: linux-scsi@vger.kernel.org

Hi Andrea,

I've seen this and I think it is fixed in our most recent version.

	Luben


Andrea Carpani wrote:
> I have several Tyan GX28 (B2881) motherboards, model B2881G28U4H with 2
> enbedded adaptec controllers:
> 
> 0000:02:0a.0 SCSI storage controller: Adaptec AIC-7902 U320 (rev 10)
>         Subsystem: Adaptec: Unknown device ffff
>         Flags: bus master, 66Mhz, slow devsel, latency 64, IRQ 24
>         I/O ports at 9000 [disabled] [size=fc780000]
>         Memory at fc89c000 (64-bit, non-prefetchable) [size=8K]
>         I/O ports at 9c00 [disabled] [size=256]
>         Expansion ROM at 00080000 [disabled]
>         Capabilities: [dc] Power Management version 2
>         Capabilities: [a0] Message Signalled Interrupts: 64bit+
> Queue=0/1 Enable-
>         Capabilities: [94]
> 0000:02:0a.1 SCSI storage controller: Adaptec AIC-7902 U320 (rev 10)
>         Subsystem: Adaptec: Unknown device ffff
>         Flags: bus master, 66Mhz, slow devsel, latency 64, IRQ 25
>         I/O ports at 9800 [disabled] [size=fc800000]
>         Memory at fc89e000 (64-bit, non-prefetchable) [size=8K]
>         I/O ports at 9400 [disabled] [size=256]
>         Expansion ROM at 00080000 [disabled]
>         Capabilities: [dc] Power Management version 2
>         Capabilities: [a0] Message Signalled Interrupts: 64bit+
> Queue=0/1 Enable-
>         Capabilities: [94]
> 
> I'm using Justin's drivers found at
> http://people.freebsd.org/~gibbs/linux/ (ver: 2.0.12) as the ones found
> on the main kernel tree are too unstable for me.
> 
> These drivers work quite well once the system is booted, but often fail
> to initialize correctly at boot time: the kernel often hangs while
> trying to initialize the scsi subsystem as you can see here:
> 
> http://www.carpani.net/temp/DSCN1503.JPG
> 
> On one of the boxes, in particular, the error happens 100% of the time.
> 
> Here are my questions
> - has anyone seen the same errors?
> - is there somewhere an updated version of these drivers?
> - any ideas?
> 

