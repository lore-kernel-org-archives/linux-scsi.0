From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [linux-usb-devel] [2.6-test] Bug in usb-storage or scsi?
Date: 12 Sep 2003 12:43:14 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1063392194.3677.7.camel@patehci2>
References: <3F5E434D.6080801@unixsol.org>
	 <Pine.LNX.4.44L0.0309101219190.905-100000@ida.rowland.org>
	 <20030910170227.C3367@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:41876 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261872AbTILSmR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2003 14:42:17 -0400
In-Reply-To: <20030910170227.C3367@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: stern@rowland.harvard.edu, mdharm-usb@one-eyed-alien.net, usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org


> From: Patrick Mansfield <patmans@us.ibm.com>
> ...
> last April: ... changes since then
> in how the MODE SENSE is handled (sd.c only?)

Anybody know more?

> If you moved a device from one transport to
> another, the commands sent to the device
> should not change: for example, you move an
> iSCSI attached device onto your local system
> via SPI.

Eh?

I thought in linux we have competing cdb authors on purpose.  For
example, how sr decides if a device is writable differs from how ide-cd
decides if a device is writable.  I thought that the powers that be like
linux that way.

No?

Having multiple cdb authors necessarily means that the cdb's passed thru
one kind of transport or another do differ any time the multiple
versions of copy-edited authoring code differ.

In particular, people designing an unusual device to work with linux
have to repeat their work: once for sr, again for ide-cd, and so on.

No?

Pat LaVarre



