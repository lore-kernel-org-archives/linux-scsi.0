From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: [PATCH] SCSI: limit mode sense usage
Date: Tue, 28 Oct 2003 14:17:02 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0310281408540.793-100000@ida.rowland.org>
References: <1067357742.1105.37.camel@ronald.kuetemeier.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:16900 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261476AbTJ1TRC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 14:17:02 -0500
In-Reply-To: <1067357742.1105.37.camel@ronald.kuetemeier.com>
List-Id: linux-scsi@vger.kernel.org
To: Ronald Kuetemeier <ronald@kuetemeier.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Tue, 28 Oct 2003, Ronald Kuetemeier wrote:

> Alan,
> sorry. Still working on my coffee.
> I just looked at my .config and debug is turned on:
> 
> CONFIG_USB_STORAGE=y
> CONFIG_USB_STORAGE_DEBUG=y
> 
> Any special sysctl you want me to set, didn't see anything in the
> Documentation/usb dir to this regard.
> And while I'm on it, do you need scsi debugging info with the usb debug
> info, to see the interaction. Or should I just use usb debug?
> Thanks,
> Ronald

That should be fine.  I asked because I didn't see any usb-storage 
debugging messages in the log you posted on Monday (err_messages.txt).

Usb-storage debugging alone should be enough.  No need for special 
sysctl's or scsi debugging.  While I don't expect this will give us a lot 
of new information, it should at least illustrate more precisely the exact 
nature of the failure mode.

Alan Stern



