From: Rask Ingemann Lambertsen <rask@sygehus.dk>
Subject: Re: State of NCR53c7xx based drivers
Date: Tue, 25 Nov 2003 17:01:12 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031125170109.E1107@sygehus.dk>
References: <20031124152653.A1292@sygehus.dk> <Pine.LNX.4.44.0311250551380.22816-100000@leo.crm114.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0x50a144f4.albnxx15.adsl-dhcp.tele.dk ([80.161.68.244]:36868
	"EHLO 0x50a144f4.albnxx15.adsl-dhcp.tele.dk") by vger.kernel.org
	with ESMTP id S261188AbTKYQBP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Nov 2003 11:01:15 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311250551380.22816-100000@leo.crm114.net>; from kent@werple.net.au on Tue, Nov 25, 2003 at 06:13:48AM +1100
List-Id: linux-scsi@vger.kernel.org
To: Ken Tyler <kent@werple.net.au>
Cc: Linux/m68k <linux-m68k@lists.linux-m68k.org>, linux-scsi@vger.kernel.org

On Tue, Nov 25, 2003 at 06:13:48AM +1100, Ken Tyler wrote:

> > The Zorro<->PPC logic should be out of the equation on the CyberStorm PPC
> > since the 53c770 is connected directly to the processor bus.
> 
> I was meaning BUS REQ, GRANT and ACK bus arbitration logic and DMA cycle
> control that is used to manage DMA transfers rather than the ZORRO auto 
> config hardware. 

So was I. If the buffer memory is also on the CyberStorm board, the bus
cycles might not even be visible outside of the processor board. Even if
they are for motherboard memory, the Buster chip does not run bus cycles
on the Zorro bus in that case.

-- 
Regards,
Rask Ingemann Lambertsen
