From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Tue, 24 Jun 2008 10:59:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0806241057430.2160-100000@iolanthe.rowland.org>
References: <804dabb00806232025m31ba0826lbddac040428e974f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:39001 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753622AbYFXO7V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jun 2008 10:59:21 -0400
In-Reply-To: <804dabb00806232025m31ba0826lbddac040428e974f@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maciej Rutecki <maciej.rutecki@gmail.com>, Peter Teoh <htmldeveloper@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 24 Jun 2008, Peter Teoh wrote:

> Yes, it worked (based on latest linus git tree) the before and after
> patch dmesg are as follows:
...
> [  387.018573] sd 3:0:0:0: [sde] Write Protect is on

> After patching and recompiling and reboot:
...
> [  230.282708] sd 3:0:0:0: [sdd] Write Protect is off

How about you, Maciej?  I want to make sure it fixes your problem too 
before submitting the patch.

Alan Stern

