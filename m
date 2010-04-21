From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 21 Apr 2010 12:09:57 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1004211205560.1728-100000@iolanthe.rowland.org>
References: <515715.64668.qm@web31814.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:50438 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755889Ab0DUQKB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2010 12:10:01 -0400
In-Reply-To: <515715.64668.qm@web31814.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Jonas Schwertfeger <jschwertfeger@gmail.com>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, "<linux-scsi@vger.kernel.org>" <linux-scsi@vger.kernel.org>, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>, "<Dinh.Nguyen@freescale.com>" <Dinh.Nguyen@freescale.com>, Mark Lord <mlord@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, "<linux-hotplug@vger.kernel.org>" <linux-hotplug@vger.kernel.org>, "<linux-usb@vger.kernel.org>" <linux-usb@vger.kernel.org>

On Wed, 21 Apr 2010, Luben Tuikov wrote:

> The Sector Count field in the ATA PASS-THROUGH (12) or (16) CDB
> should be set appropriately by the Application Client as the neither
> the SAT bridge nor the SATA transport will interpret the ATA Command
> byte. Thus, for IDENTIFY (PACKET) DEVICE the Application Client
> should set it to 1.
> 
> Why do you say that 1 is the appropriate value?  In the ATA-5 spec
> (which is the most recent version I have) Sector Count is listed as
> "na" for IDENTIFY DEVICE, which means that the content of that field is
> not applicable to this particular command.  Hence the value shouldn't 
> matter.
> 
> It is needed by the transport protocol(s). 

I don't understand; can you explain more fully?  Which transport 
protocol(s) need to use the Sector Count?  The USB transport protocol 
doesn't; it encodes the transfer length in a wrapper.  The bridge chip 
should interpret the wrapper instead of looking inside the SAT command.

Alan Stern

