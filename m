From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: megaraid not working in 2.6.18
Date: Tue, 10 Oct 2006 07:03:30 -0600
Message-ID: <890BF3111FB9484E9526987D912B261932E3CE@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:25228 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750698AbWJJNDg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 09:03:36 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Csillag Tamas <cstamas@digitus.itk.ppke.hu>, linux-scsi@vger.kernel.org

 
Hi,
> However the legacy megaraid drivers does not work either. I get
> unknown-block-device error when the kernel tries to mount sdaX.
> I do not even see the megaraid driver coming up! no detecting 
> messages like
> in 2.6.11
>From 2.6.13 or later, old megaraid controllers, like yours, has to go with megaraid legacy driver.
I'm not sure why the driver gets failed to load. 
For further assist, please contact LSI customer service if you bought directly from LSI, or contact your system maker.

Thank you,

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Csillag Tamas
> Sent: Tuesday, October 10, 2006 5:07 AM
> To: linux-scsi@vger.kernel.org
> Subject: megaraid not working in 2.6.18
> 
> hi,
> 
> I have two servers with AMI megaraid.
> They both runnig 2.6.11.*
> 
> I want to upgrade to 2.6.18. The problem is: the driver does not work
> anymore.
> 
> If I try the new driver, the kernel freezes after I see a stack trace
> dump. It is OK, I read somewhere that I should not use this new one as
> it does not support my old cards.
> 
> However the legacy megaraid drivers does not work either. I get
> unknown-block-device error when the kernel tries to mount sdaX.
> I do not even see the megaraid driver coming up! no detecting 
> messages like
> in 2.6.11
> 
> This page: http://linux.dell.com/storage.shtml#megaraid lead 
> me to this
> list.
> 
> # lspci -v
> 0000:00:00.0 Host bridge: ServerWorks CNB20LE Host Bridge (rev 06)
>         Flags: bus master, medium devsel, latency 48
> 
> 0000:00:00.1 Host bridge: ServerWorks CNB20LE Host Bridge (rev 06)
>         Flags: bus master, medium devsel, latency 32
> 
> 0000:00:02.0 Ethernet controller: Intel Corp. 82557/8/9 
> [Ethernet Pro 100] (rev 0d)
>         Subsystem: Hewlett-Packard Company NetServer 10/100TX
>         Flags: bus master, medium devsel, latency 64, IRQ 10
>         Memory at fd020000 (32-bit, non-prefetchable) [size=4K]
>         I/O ports at 1800 [size=64]
>         Memory at fd000000 (32-bit, non-prefetchable) [size=128K]
>         Capabilities: [dc] Power Management version 2
> 
> 0000:00:04.0 Ethernet controller: Intel Corp. 82557/8/9 
> [Ethernet Pro 100] (rev 08)
>         Subsystem: Hewlett-Packard Company NetServer 10/100TX
>         Flags: bus master, medium devsel, latency 64, IRQ 5
>         Memory at fd021000 (32-bit, non-prefetchable) [size=4K]
>         I/O ports at 1840 [size=64]
>         Memory at fd100000 (32-bit, non-prefetchable) [size=1M]
>         Capabilities: [dc] Power Management version 2
> 
> 0000:00:06.0 RAID bus controller: American Megatrends Inc. 
> MegaRAID (rev 20)
>         Subsystem: Hewlett-Packard Company: Unknown device 60e7
>         Flags: bus master, medium devsel, latency 64, IRQ 11
>         Memory at fd400000 (32-bit, prefetchable) [size=64K]
>         Capabilities: [80] Power Management version 2
> 
> 0000:00:07.0 VGA compatible controller: ATI Technologies Inc 
> Rage XL (rev 27) (prog-if 00 [VGA])
>         Subsystem: Hewlett-Packard Company: Unknown device 10e1
>         Flags: bus master, stepping, medium devsel, latency 66, IRQ 11
>         Memory at fc000000 (32-bit, non-prefetchable) [size=16M]
>         I/O ports at 1400 [size=256]
>         Memory at fd022000 (32-bit, non-prefetchable) [size=4K]
>         Capabilities: [5c] Power Management version 2
> 
> 0000:00:0f.0 Host bridge: ServerWorks CSB5 South Bridge (rev 93)
>         Subsystem: Hewlett-Packard Company: Unknown device 129b
>         Flags: bus master, medium devsel, latency 32
> 
> 0000:00:0f.1 IDE interface: ServerWorks CSB5 IDE Controller 
> (rev 93) (prog-if 8a [Master SecP PriP])
>         Subsystem: Hewlett-Packard Company: Unknown device 129b
>         Flags: bus master, medium devsel, latency 32
>         I/O ports at <ignored>
>         I/O ports at <ignored>
>         I/O ports at <ignored>
>         I/O ports at <ignored>
>         I/O ports at 1880 [size=16]
> 
> 0000:00:0f.2 USB Controller: ServerWorks OSB4/CSB5 OHCI USB 
> Controller (rev 05) (prog-if 10 [OHCI])
>         Subsystem: Hewlett-Packard Company: Unknown device 129b
>         Flags: medium devsel, IRQ 11
>         Memory at fd023000 (32-bit, non-prefetchable) [size=4K]
> 
> 0000:00:0f.3 ISA bridge: ServerWorks CSB5 LPC bridge
>         Subsystem: Hewlett-Packard Company: Unknown device 129b
>         Flags: bus master, medium devsel, latency 0
> 
> 0000:05:04.0 SCSI storage controller: LSI Logic / Symbios 
> Logic 53c1010 66MHz  Ultra3 SCSI Adapter (rev 01)
>         Subsystem: Hewlett-Packard Company: Unknown device 60a0
>         Flags: bus master, 66MHz, medium devsel, latency 72, IRQ 9
>         I/O ports at 1c00 [size=256]
>         Memory at fd412000 (64-bit, non-prefetchable) [size=1K]
>         Memory at fd410000 (64-bit, non-prefetchable) [size=8K]
>         Capabilities: [40] Power Management version 2
> 
> 0000:05:04.1 SCSI storage controller: LSI Logic / Symbios 
> Logic 53c1010 66MHz  Ultra3 SCSI Adapter (rev 01)
>         Subsystem: Hewlett-Packard Company: Unknown device 60a0
>         Flags: bus master, 66MHz, medium devsel, latency 72, IRQ 11
>         I/O ports at 2000 [size=256]
>         Memory at fd412400 (64-bit, non-prefetchable) [size=1K]
>         Memory at fd414000 (64-bit, non-prefetchable) [size=8K]
>         Capabilities: [40] Power Management version 2
> 
> I attach my kernel config file too (for 2.6.18).
> 
> Thanks in advance. Ask for more info if needed.
> please cc to me.
> -- 
> 
> CSILLAG Tamas (cstamas) - http://digitus.itk.ppke.hu/~cstamas
> 
