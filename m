From: Ken Tyler <kent@werple.net.au>
Subject: Re: State of NCR53c7xx based drivers
Date: Tue, 25 Nov 2003 06:13:48 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311250551380.22816-100000@leo.crm114.net>
References: <20031124152653.A1292@sygehus.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gizmo03bw.bigpond.com ([144.140.70.13]:44940 "HELO
	gizmo03bw.bigpond.com") by vger.kernel.org with SMTP
	id S263846AbTKXTNx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 14:13:53 -0500
In-Reply-To: <20031124152653.A1292@sygehus.dk>
List-Id: linux-scsi@vger.kernel.org
To: Rask Ingemann Lambertsen <rask@sygehus.dk>
Cc: Linux/m68k <linux-m68k@lists.linux-m68k.org>, linux-scsi@vger.kernel.org

On Mon, 24 Nov 2003, Rask Ingemann Lambertsen wrote:

> On Mon, Nov 24, 2003 at 04:12:02PM +1100, Ken Tyler wrote:

> I'm confused. What SCSI on PPC A4000s is that? Is it the 53c770 on the
> CyberStorm PPC or the 53c710 on the A4000 tower motherboard?

Sorry, not clear at all, 53c710 on DKB A4091 in A4000 (not tower) ZORRO 
slot, with Cyberstorm 060 and 200MHz 604e.

Is there a 53c710 in A4000 towers and if so is it on the mother board at a 
fixed address?

> The Zorro<->PPC logic should be out of the equation on the CyberStorm PPC
> since the 53c770 is connected directly to the processor bus.

I was meaning BUS REQ, GRANT and ACK bus arbitration logic and DMA cycle
control that is used to manage DMA transfers rather than the ZORRO auto 
config hardware. 

I recall reading that the PPC on the Cyberstorm cards is made to look like
a 68000 to talk on the ZORRO bus.

I assume that the same arbitration logic is used for bus control even 
though the Cyberstorm on board SCSI is at a fixed address and doesn't need 
to be allocated a ZORRO address range as a real plug in ZORRO card does.

Does that make any sense?

Ken.

