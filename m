From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Fri, 25 Apr 2003 17:12:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200304251712.41252.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0304251009030.30350-100000@netrider.rowland.org>
Reply-To: oliver@neukum.name
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mail1.KONTENT.De ([81.88.34.36]:10648 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S263277AbTDYPAe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 11:00:34 -0400
In-Reply-To: <Pine.LNX.4.44L0.0304251009030.30350-100000@netrider.rowland.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Andries.Brouwer@cwi.nl
Cc: stelian@popies.net, James.Bottomley@steeleye.com, afafc@rnl.ist.utl.pt, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, USB development list <linux-usb-devel@lists.sourceforge.net>, pwkpete@yahoo.com


> To begin with, in my opinion the LLDD should do a minimum of filtering and
> altering.  Not only is it frequently difficult to know if such actions are
> valid or will be acceptable to the caller, there is also the principle
> that user-generated requests (via the scsi-generic interface) should be
> left totally alone -- after all, the user may be probing precisely to
> determine whether or not the device will accept a particular command.

Seriously, why this principle? It makes user space drivers inferior in
some respects. After all, we usually require a special capability to
allow actions that can crash hardware.

> (1) is obviously necessary.  In general, refusing to accept a command is
> better than changing it, IMO.

Better it would not be issued in the first place.

[..]
> This puts the burden of dealing with partially-compliant devices on the
> SCSI midlayer.  The routines there should be prepared to issue multiple
> forms of a some commands, so that if one form doesn't work another form
> can be tried.  Of course, this is already being done for READ and WRITE.

Wouldn't it be better if drivers had attributes which tell the midlevel
which forms of the several commands are acceptable?

	Regards
		Oliver

