From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Mon, 20 Jan 2003 20:10:13 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301202010.13443.oliver@neukum.name>
References: <10426732153816@kroah.com> <200301201923.50467.oliver@neukum.name> <3E2C4678.1090508@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E2C4678.1090508@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


> > We as the writers of device drivers need a way to get rid of the device
> > as we are notified of the physical disconnect.
>
> Yes, and as I explained earlier: you *may* get notified by the transport.

That exactly is the point. There must be no maybe. Gone is gone.
Failure is not an option here.
Only LLDD knows reliably whether a device is gone and there can
be no second guessing by higher levels. Consequently, the LLDD
reports it and the higher layers delete the device as gently as possible,
but delete it in any case.

	Regards
		Oliver

