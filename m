From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Serial Attached SCSI Driver Interface (SDI)
Date: Mon, 15 Nov 2004 13:14:44 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B5C0F4F@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:4226 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261658AbUKOSQi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 13:16:38 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Tuikov, Luben" <Luben_Tuikov@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Eric.Moore@lsil.com

For a) design flaw, probably, but a cross-OS standard is still better
than nothing. One built-in design flaw is that a standard will
necessarily be a subset of the needs of the users and the various
management applications.

For b) So, there is a standard Hardware RAID management ioctl mechanism
in Linux? The duplication has all been going into each and every H/W
RAID card's driver.

The goals of most H/W RAID card's management passthrough functions
invariably bends to the purposes of the management application needs and
the underlying Firmware architecture. Bridging application space into
the driver has also been cross purpose to the goals of the OS internals
designers.

What is needed is that we all come to an agreement as to the necessity
for management application passthrough into the Firmware. Once we have
that, maybe a standard that makes sense in the scsi core can take root.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Jeff Garzik [mailto:jgarzik@pobox.com] 
Sent: Monday, November 15, 2004 1:02 PM
To: Salyzyn, Mark
Cc: Tuikov, Luben; SCSI Mailing List; Eric.Moore@lsil.com
Subject: Re: Serial Attached SCSI Driver Interface (SDI)

Salyzyn, Mark wrote:
> CSMI is an ioctl mechanism. Have incorporated this interface into my
> working version of the driver. Duplication is already showing, witness
> Eric Moore's (rejected) submission.
> 
> The T10 document Luben refers to, is to start the groundwork and does
> not list any specific interface yet. March 2006 is the `public release
> data' ... Get your comments in now!


ug.

These ioctl mechanisms almost always (a) have design flaws [which cannot

be corrected, since they are in a spec] and (b) duplicate other 
functionality of the Linux kernel.  The SNIA ioctl mess is a great 
example of this.

Without any additional info, my first reaction is that this is yet more 
stuff Linux doesn't need.

	Jeff


