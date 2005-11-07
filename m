From: "Timothy Thelin" <Timothy.Thelin@wdc.com>
Subject: RE: [usb-storage] [Merging ATA passthru] on integratingSMART/ATA-Security in usb-storage driver
Date: Mon, 7 Nov 2005 14:50:09 -0800
Message-ID: <CA45571DE57E1C45BF3552118BA92C9D69BF46@WDSCEXBECL03.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, thomas schorpp <t.schorpp@gmx.de>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org




> On Mon, 2005-11-07 at 15:59 -0500, Alan Stern wrote:
> > > That is, is usb-storage forcing scsi-2 when the device 
> tells us it is
> > > scsi-3 compliant, or is the hardware reporting devices 
> are scsi-2, yet
> > > requiring non-LUN value in cdb[1]?
> > 
> > I think we may have both.  However I don't know how this 
> Cypress chip
> > reports itself.  A system log showing the INQUIRY data would be very
> > helpful.
> 
> We were told in prior emails that it actually reports a level of zero
> (i.e. no compliance with any SCSI standard).  My original proposal was
> just not to modify the CDB[1] for this case if we could get 
> the INQUIRY
> passed through unmangled.

Here is the inquiry data on my CY7C68300B:
00-03: 00 00 00 00
04-07: 1F 00 00 00
08-11: 57 44 43 20
12-15: 57 44 34 30
16-19: 30 55 45 2D
20-23: 30 30 48 43
24-27: 54 30 20 20
28-31: 20 20 20 20
32-35: 30 30 30 30
36-39: 00 00 00 00
40-43: 00 00 00 00

Regards,
Tim Thelin
