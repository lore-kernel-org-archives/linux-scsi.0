From: Jeff Garzik <jeff@garzik.org>
Subject: Re: megaraid_sata vs megasr
Date: Mon, 26 May 2008 13:11:26 -0400
Message-ID: <483AEF3E.5010309@garzik.org>
References: <200805261005.31015.maarten@ba.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:34015 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbYEZRL3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 May 2008 13:11:29 -0400
In-Reply-To: <200805261005.31015.maarten@ba.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maarten Vanraes <maarten@ba.be>
Cc: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

Maarten Vanraes wrote:
> Hello, (can you CC me? i'm not on the list)
> 
> I have a LSI MegaRAID SAS 8204ELP card, and since it wasn't recognized by any 
> driver, i tried using the megasr driver supplied by LSI (it also supplies 
> open_source code with it), i had to modify the code a bit to get it to boot 
> with kernel-2.6.21 . but there's a very high iowait on it. i'm wondering if 
> the megaraid_sas driver is meant to be the driver for the same hardware as 
> megasr? would it help if i just added another PCI ID to the module and try 
> that one?
> 
> Sincerely,
> 
> Maarten Vanraes
> 
> [] # lspci -s 08:00.0 -vvvn
> 08:00.0 0100: 1000:0059 (rev 08)
>         Subsystem: 1000:3002
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
> Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR+ <PERR- INTx-
>         Latency: 0, Cache Line Size: 32 bytes
>         Interrupt: pin A routed to IRQ 18
>         Region 0: I/O ports at 3000 [size=256]
>         Region 1: Memory at d8410000 (64-bit, non-prefetchable) [size=16K]
>         Region 3: Memory at d8400000 (64-bit, non-prefetchable) [size=64K]
>         [virtual] Expansion ROM at d8000000 [disabled] [size=2M]
>         Capabilities: [50] Power Management version 2
>         Capabilities: [68] Express (v1) Endpoint, MSI 00
>         Capabilities: [98] Message Signalled Interrupts: Mask- 64bit+ 
>         Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1
>         Capabilities: [100] Advanced Error Reporting <?>

Yeah you can try drivers/scsi/megaraid/megaraid_sas.c or 
drivers/message/fusion/mptsas.c.

A URL to the megasr driver would be nice.

Also, please keep linux-scsi in CC (I added it), that's where this sort 
of things is usually discussed.

	Jeff



