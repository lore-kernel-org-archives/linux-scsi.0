From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Sat, 26 Apr 2003 10:24:37 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200304261024.37470.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0304252046570.5053-100000@netrider.rowland.org>
Reply-To: oliver@neukum.name
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mail1.KONTENT.De ([81.88.34.36]:12732 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S263129AbTDZIM3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2003 04:12:29 -0400
In-Reply-To: <Pine.LNX.4.44L0.0304252046570.5053-100000@netrider.rowland.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andries.Brouwer@cwi.nl, stelian@popies.net, James.Bottomley@steeleye.com, afafc@rnl.ist.utl.pt, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, USB development list <linux-usb-devel@lists.sourceforge.net>, pwkpete@yahoo.com


> Do you mean it makes user space drivers inferior to kernel drivers?  I
> don't see how.  The LLDD would treat them both the same, doing a minimum
> of modifications.

You got to make up your mind :-)
So the LLDD should filter in both cases?

> If you mean that it would make user space drivers inferior to the way they
> work now, then I agree.  At least, they might be inferior in terms of
> performance, since they would no longer have commands altered
> automatically for their benefit.  On the other hand, they would be
> superior in terms of receiving a more transparent channel directly to the
> device.  For some people this is very important.

For the larger part it's vastly important that exactly that doesn't happen.
Eg. I want the user to have access to a device, but I don't want him to
be able to crash the device. It's a multiuser system and others might
want to use the device afterwards.
We usually require root level to get a transparent channel to hardware.

If filtering is marginal you need to use yet another demon to be checked for
buffer overflows, etc. ... .

> I think it won't really be a problem.  A user-space driver _ought_ to be
> prepared to cope with the quirks and special requirements of a particular
> device.

But can you depend on it? From an administration viewpoint you create a
hole for a DoS attack.

	Regards
		Oliver

