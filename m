From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH fix for 3.17] uas: Add a quirk for rejecting ATA_12 and
 ATA_16 commands
Date: Mon, 15 Sep 2014 13:12:36 +0200
Message-ID: <1410779556.6635.6.camel@linux-fkkt.site>
References: <1410603548-3579-2-git-send-email-hdegoede@redhat.com>
	 <Pine.LNX.4.44L0.1409131009530.7476-100000@netrider.rowland.org>
	 <063D6719AE5E284EB5DD2968C1650D6D17491F5F@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D17491F5F@AcuExch.aculab.com>
Sender: stable-owner@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'Alan Stern' <stern@rowland.harvard.edu>, Hans de Goede <hdegoede@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2014-09-15 at 08:42 +0000, David Laight wrote:
> From: Alan Stern
>  
> > You must not add an aditional value for a module parameter without
> > documenting it in Documentation/kernel-parameters.txt.
> 
> How can this work as a 'module parameter'?

It cannot. This parameter is an aid to debugging.

> I might want to use two different usb-scsi devices that have different
> requirements.

Indeed. Quirky devices must be added to the quirks file.

	Regards
		Oliver
