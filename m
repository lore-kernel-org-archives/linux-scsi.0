From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH fix for 3.17] uas: Add a quirk for rejecting ATA_12 and
 ATA_16 commands
Date: Mon, 15 Sep 2014 10:56:08 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1409151048110.1360-100000@iolanthe.rowland.org>
References: <1410779556.6635.6.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1410779556.6635.6.camel@linux-fkkt.site>
Sender: stable-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: David Laight <David.Laight@ACULAB.COM>, Hans de Goede <hdegoede@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 15 Sep 2014, Oliver Neukum wrote:

> On Mon, 2014-09-15 at 08:42 +0000, David Laight wrote:
> > From: Alan Stern
> >  
> > > You must not add an aditional value for a module parameter without
> > > documenting it in Documentation/kernel-parameters.txt.
> > 
> > How can this work as a 'module parameter'?
> 
> It cannot. This parameter is an aid to debugging.

Not true; it really is a module parameter and can be used for multiple
devices at once.  And while it is meant partially for debugging, it's
also meant for testing or for when there's no permanent unusual_devs
quirk entry.

> > I might want to use two different usb-scsi devices that have different
> > requirements.
> 
> Indeed. Quirky devices must be added to the quirks file.

As Hans said (and as described in Documentation/kernel-parameters.txt), 
the parameter format is a comma-separated list of 
vendor-id:product-id:flags triples.

Alan Stern
