From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: How to find which (physical) SCSI HBA corresponds to which ho	st number?
Date: Fri, 1 Apr 2005 15:05:05 -0500
Message-ID: <200504012005.j31K5Am19844@www.watkins-home.com>
References: <OF48E31788.A91E33AF-ON88256FD6.00605364-88256FD6.00619462@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc13.comcast.net ([204.127.198.39]:62143 "EHLO
	rwcrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S262868AbVDAUFP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2005 15:05:15 -0500
In-Reply-To: <OF48E31788.A91E33AF-ON88256FD6.00605364-88256FD6.00619462@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Bryan Henderson' <hbryan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, "'Rajat Jain, Noida'" <rajatj@noida.hcltech.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Bryan Henderson
> Sent: Friday, April 01, 2005 12:47 PM
> To: Rajat Jain, Noida
> Cc: linux-scsi@vger.kernel.org; Rajat Jain, Noida
> Subject: RE: How to find which (physical) SCSI HBA corresponds to which ho
> st number?
> 
> >>proc/scsi/hba_name/host_number.
> >
> >This proc entry is made AFTER the device is registered with SCSI
> mid-level
> >driver (scsi_mod).
> 
> This proc entry is not related to a device.  It's the entry that describes
> the HBA, and it gets created as part of registering the HBA (host).
> 
> >after I add a SCSI device to one of the HBAs, the only
> >option I have left with me is following
> >
> >For n = 0 to N
> >Do
> >                echo "scsi add-single-device n 0 ID 0" > /proc/scsi/scsi
> 
> If you and Linux could identify the host in common terms, you wouldn't
> have to do this.  But the question is open as to in what terms you
> personally identify the host to which you attached the device.  Is it the
> controller to the west?  The red one?  The new one?  The one with serial
> number 8436547?  The one at PCI address X:Y:Z?  The one that has your disk
> drives on it?

It would be great is Linux could maintain IDs based on a hardware address.
If PCI X:Y:Z is real, then this would be my choice.  Using this method, one
could replace a card and still have the same IDs.  Or add/remove a card(s).
I added a tape drive and of course, it became st0 and my old tape drive
became st1.  Not very well though out.  IMO.
> 
> The host proc file often has a serial number in it.  Sometimes it has a
> fibre channel worldwide node name.
> 
> It seems to me that you're probably right, though: the easiest thing is
> just to try to add the bus/target/LUN to every host.  In an ideal world,
> you'd do this with hotplug.

Guy

