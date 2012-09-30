From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Sun, 30 Sep 2012 15:43:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1209301533280.18360-100000@netrider.rowland.org>
References: <50689794.50203@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <50689794.50203@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Aaron Lu <aaron.lu@intel.com>, Oliver Neukum <oneukum@suse.de>, 'James Bottomley' <James.Bottomley@hansenpartnership.com>, Linux-pm mailing list <linux-pm@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 30 Sep 2012, Jeff Garzik wrote:

> The simple fact of "only ZPODD devices out there are ATA" is not the 
> decision-maker for where the code should live.  It is more a question 
> where ZPODD belongs in the device/command set model currently employed.

I don't really accept this argument.  It's a little like saying: The
tty layer uses ioctl commands to control RS232 line settings; therefore
RS232 settings should be handled in the VFS layer as part of the ioctl
core.

Regardless, according to Aaron the ZP power-off stuff is currently
implemented only in ACPI, tied more closely to the ATA layer than the
SCSI layer (though not part of either).  It is not part of the SCSI
spec in any form.  Now it's true that determining whether a device is
in the right state for power to be removed involves sending a TEST UNIT
READY command, which is of course a SCSI command.  This seems to be
incidental to the overall scheme, however.

Alan Stern

