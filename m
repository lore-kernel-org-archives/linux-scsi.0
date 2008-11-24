From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: Conversion of old Amiga NCR53C9x drivers to esp_scsi
Date: Mon, 24 Nov 2008 22:08:33 +0100 (CET)
Message-ID: <alpine.DEB.1.00.0811242206540.22809@zirkon.biophys.uni-duesseldorf.de>
References: <1227560510.15190.18.camel@kars.perseus.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-m68k-owner@vger.kernel.org>
In-reply-to: <1227560510.15190.18.camel@kars.perseus.home>
Sender: linux-m68k-owner@vger.kernel.org
To: Kars de Jong <jongk@linux-m68k.org>
Cc: Linux/m68k kernel mailing list <linux-m68k@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

> After an initial failure in February this year I have now gotten my
> Blizzard SCSI Kit IV to work with the esp_scsi core.

Congratulations!
 
> It turns out the DMA engine doesn't like a transfer size of only 2 bytes
> (at least not when receiving). The bytes were in the FSC FIFO, but
> didn't get transferred to DRAM and the final interrupt didn't occur so
> the driver got stuck.
> 
> The old driver used to do such small transfers using PIO, so that is
> what I do now in the glue driver.
> 
> What is the way to go? Revive the glue named drivers/scsi/blz1230.c?
> Or should it be renamed?

I'd rename it to blz1230_esp.c. 
 
> Some of the other drivers may be a little more problematic because they
> had more driver operations which are not present in the esp_scsi DMA
> abstraction.

Can you fall back to PIO for those cases? 

	Michael
