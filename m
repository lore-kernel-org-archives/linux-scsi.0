From: Oliver.Neukum@lrz.uni-muenchen.de
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 24 Jan 2003 23:23:41 +0100 (MET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.SOL.4.44.0301242322110.24678-100000@sun1.lrz-muenchen.de>
References: <3E318D5F.20200@splentec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E318D5F.20200@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.name>, Doug Ledford <dledford@redhat.com>, David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

On Fri, 24 Jan 2003, Luben Tuikov wrote:

> Alan Stern wrote:
>  >
> > Matt's current proposed patch has the USB LLDD calling
> > scsi_unregister_host()  (because the device is respresented as an emulated
>
> A LLDD should and must *not* call scsi_unregister_host().  This brakes
> all hierarchy.

What then is supposed to happen when you remove a PCMCIA host adapter or
a SCSI to USB bridge or ... ?
There must be a way to report that a host was unplugged.

	Regards
		Oliver


