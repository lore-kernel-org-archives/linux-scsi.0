From: Ballabio_Dario@emc.com
Subject: RE: eata irq abuse (was: Re: Linux 2.5.60)
Date: Wed, 12 Feb 2003 09:13:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <70652A801D9E0C469C28A0F8BCF49CF9012EBA97@itmi1mx2.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, Ballabio_Dario@emc.com
Cc: manfred@colorfullife.com, warp@mercury.d2dc.net, linux-scsi@vger.kernel.org

Last time I tried to run the detect routine with interrupts enabled,
it just hung at the first occurrence on an inb() from
the board registers. If someone is able to have it 
working with interrupts enabled and qualifies the
solution on all the platforms and eata boards,
I'd be more than happy to remove it.

-db


-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org]
Sent: Wednesday, February 12, 2003 2:17 PM
To: Ballabio_Dario@emc.com
Cc: manfred@colorfullife.com; warp@mercury.d2dc.net;
linux-scsi@vger.kernel.org
Subject: Re: eata irq abuse (was: Re: Linux 2.5.60)


On Wed, Feb 12, 2003 at 07:47:01AM -0500, Ballabio_Dario@emc.com wrote:
> The enclosed patch applies to 2.5.60 and fixes the irq issue when calling
> scsi_register for both eata and u14-34f drivers.

Any chance you could explain us

(1) what does this lock protect
(2) why does it need to disable interrupts
