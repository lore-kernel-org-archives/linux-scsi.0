From: Ken Tyler <kent@werple.net.au>
Subject: Re: State of NCR53c7xx based drivers
Date: Wed, 26 Nov 2003 07:17:21 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311260702360.7074-100000@leo.crm114.net>
References: <20031125170109.E1107@sygehus.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gizmo01bw.bigpond.com ([144.140.70.11]:6869 "HELO
	gizmo01bw.bigpond.com") by vger.kernel.org with SMTP
	id S262914AbTKYURY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 15:17:24 -0500
In-Reply-To: <20031125170109.E1107@sygehus.dk>
List-Id: linux-scsi@vger.kernel.org
To: Rask Ingemann Lambertsen <rask@sygehus.dk>
Cc: Linux/m68k <linux-m68k@lists.linux-m68k.org>, linux-scsi@vger.kernel.org

On Tue, 25 Nov 2003, Rask Ingemann Lambertsen wrote:

> So was I. If the buffer memory is also on the CyberStorm board, the bus
> cycles might not even be visible outside of the processor board. Even if
> they are for motherboard memory, the Buster chip does not run bus cycles
> on the Zorro bus in that case.

Depends on the how the hardware implements on and off board access.  I 
supposed a state machine takes the Zorro/m68k signals and generates 
appropriate signals for the ppc and vise versa.  The same state machine 
handles the onboard SCSI DMA but as you say there are differences.

According to www.thule.no/haynie/ even the last rev buster had problems, I 
have some emails from him some where on this.

It just seems too much of a coincidence that my A4091 and the onboard 
Cyberstorm SCSI have an identical problem but wether it's hardware or 
software I've no idea.

After replacing the 040 with the 060/PPC card the Amiga OS would 
freeze now and then. I think more frequently than when the 040 was in 
place.

Ken.

