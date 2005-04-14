From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Fw: [SCSI] Driver broken in 2.6.x?
Date: Thu, 14 Apr 2005 19:45:11 +0100
Message-ID: <20050414184511.GA6743@infradead.org>
References: <20050402112809.25dee339.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:25735 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261392AbVDNSpM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2005 14:45:12 -0400
Content-Disposition: inline
In-Reply-To: <20050402112809.25dee339.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, techno@punkt.pl

> I've recently switched form 2.4.x kernel series to 2.6.x, and I've 
> encourted a problem with my old scanner card, lspci shows it as:
> 
> <begin lspci output>
> 00:0c.0 SCSI storage controller: DTC Technology Corp. Domex 536
>          Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>          Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium 
>  >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>          Interrupt: pin A routed to IRQ 11
>          Region 0: I/O ports at d800 [size=32]
> <end>
> 
> It worked flawlessly under 2.4 kernels, but now it hangs xsane, and logs 
> show this:

Unfortunately this driver is known broken under 2.6.  I tried to debug it
with Mark Morschha\"user who has such a card aswell, but we didn't manage
to find out what's wrong.

