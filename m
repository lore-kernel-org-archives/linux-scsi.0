From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass
	larger receive buffer
Date: 13 Nov 2003 12:30:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068751832.16444.78.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131200420.949-100000@ida.rowland.org>
	 <1068744259.13580.41.camel@patrh9>
	 <20031113100424.A26197@beaverton.ibm.com>
	 <1068747355.16444.22.camel@patrh9> <1068747746.16444.30.camel@patrh9>
	 <1068747998.16444.35.camel@patrh9> <1068748629.16444.58.camel@patrh9>
	 <20031113111344.B30194@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:12738 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264405AbTKMTbJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 14:31:09 -0500
In-Reply-To: <20031113111344.B30194@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: mdharm-scsi@one-eyed-alien.net
Cc: patmans@us.ibm.com, stern@rowland.harvard.edu, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

> Our experience tells us that xFF is often used because designers are one of
> the following:
> 	(a) lazy
> 	(b) incompetient

Choosing to violate spec, certainly.

> 	(c) driven by marketing, which wants to load an .inf so their
> 	device seems 'special' (custom icons, etc.)
> 
> So xFF doesn't really tell us, deterministically, anything at all.

Do we here agree violently?

bInterfaceSubClass = xFF tells us Windows does not speak to the device
with Microsoft's generic driver by default.  That .inf we do not have in
Linux may then say to use the generic driver, or may say to use some
other driver.

> Knowing that the device is direct-access, however, implies very strongly
> that MODE_SENSE[_10] is a bad idea.

Anybody able to clue me in quickly as to why classifying a device as
writable or not, rather than a disc, can ever be meaningful?

Maybe guessing not writable helps only (in the vanishingly small corner
case) when a disc is write-protectable although Not removable without
also removing the drive?

Pat LaVarre


