From: Ken Tyler <kent@werple.net.au>
Subject: Re: State of NCR53c7xx based drivers
Date: Mon, 24 Nov 2003 16:12:02 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311241553080.17702-100000@leo.crm114.net>
References: <20031123232126.B1657@sygehus.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gizmo09bw.bigpond.com ([144.140.70.19]:31463 "HELO
	gizmo09bw.bigpond.com") by vger.kernel.org with SMTP
	id S263618AbTKXFMG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 00:12:06 -0500
In-Reply-To: <20031123232126.B1657@sygehus.dk>
List-Id: linux-scsi@vger.kernel.org
To: Rask Ingemann Lambertsen <rask@sygehus.dk>
Cc: Linux/m68k <linux-m68k@lists.linux-m68k.org>, linux-scsi@vger.kernel.org

On Sun, 23 Nov 2003, Rask Ingemann Lambertsen wrote:

> I have an Amiga with a CyberStorm PPC board and wouldn't mind having Linux
> running on it. What would be a good name for the driver?

Which Amiga and which PPC board?

SCSI works on ppc 1200s but not reliably on ppc 4000s.  I tried many, many 
times to fix 53c710.c (with endless help from Richard Hirst) all to no 
avail.

It will work for a variable amount of time and then machine locks up,
CDROMS and ZIPs seem to run longer than HDs.

A hacked together sim710.c behaved exactly the same.  This is with Quantum 
drives.

An odd as it might seem when I bought a Seagate drive for the PPC on board
SCSI it did the same thing too.

At this point I decided the driver was probably OK all along and the 
problem is else where, either in the logic that connects ZORRO to PPC or a 
deadlock in interrupt code but this is stabbing in the dark.

Good luck,

Ken.   




