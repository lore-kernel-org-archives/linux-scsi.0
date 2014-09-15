From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH fix for 3.17] uas: Add a quirk for rejecting ATA_12 and
 ATA_16 commands
Date: Mon, 15 Sep 2014 08:42:00 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17491F5F@AcuExch.aculab.com>
References: <1410603548-3579-2-git-send-email-hdegoede@redhat.com>
 <Pine.LNX.4.44L0.1409131009530.7476-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0.aculab.com ([213.249.233.131]:39010 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753320AbaIOIny convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Sep 2014 04:43:54 -0400
Received: from mx0.aculab.com ([127.0.0.1])
 by localhost (mx0.aculab.com [127.0.0.1]) (amavisd-new, port 10024) with SMTP
 id 19081-08 for <linux-scsi@vger.kernel.org>;
 Mon, 15 Sep 2014 09:43:45 +0100 (BST)
In-Reply-To: <Pine.LNX.4.44L0.1409131009530.7476-100000@netrider.rowland.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Alan Stern' <stern@rowland.harvard.edu>, Hans de Goede <hdegoede@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>

From: Alan Stern
...
> >  	p = quirks;
> >  	while (*p) {
> > @@ -543,6 +544,9 @@ void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
> >  		case 's':
> >  			f |= US_FL_SINGLE_LUN;
> >  			break;
> > +		case 't':
> > +			f |= US_FL_NO_ATA_1X;
> > +			break;
> >  		case 'u':
> >  			f |= US_FL_IGNORE_UAS;
> >  			break;
> 
> You must not add an aditional value for a module parameter without
> documenting it in Documentation/kernel-parameters.txt.

How can this work as a 'module parameter'?
I might want to use two different usb-scsi devices that have different
requirements.

	David



