From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating
	SMART/ATA-Security in usb-storage driver
Date: Mon, 07 Nov 2005 17:05:52 -0500
Message-ID: <1131401153.3333.6.camel@mulgrave>
References: <Pine.LNX.4.44L0.0511071552360.5165-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0511071552360.5165-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, thomas schorpp <t.schorpp@gmx.de>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Timothy Thelin <Timothy.Thelin@wdc.com>, Linux SCSI list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2005-11-07 at 15:59 -0500, Alan Stern wrote:
> > That is, is usb-storage forcing scsi-2 when the device tells us it is
> > scsi-3 compliant, or is the hardware reporting devices are scsi-2, yet
> > requiring non-LUN value in cdb[1]?
> 
> I think we may have both.  However I don't know how this Cypress chip
> reports itself.  A system log showing the INQUIRY data would be very
> helpful.

We were told in prior emails that it actually reports a level of zero
(i.e. no compliance with any SCSI standard).  My original proposal was
just not to modify the CDB[1] for this case if we could get the INQUIRY
passed through unmangled.

> It's quite possible that usb-storage no longer needs to force the 
> scsi-level to 2.  No one has recently tested what would happen without 
> it.  Matt probably has the best selection of devices for testing...
> 
> There is one problem we have with devices that report themselves as SCSI-3 
> or SCSI-4 but hang when they receive a REPORT LUNS command.  That's easily 
> handled by making usb-storage set the NOREPORTLUN flag.  Maybe that's all 
> we need to do.

If you could try this out, I'd be grateful.

Thanks,

James


