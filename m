From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 21 Apr 2010 10:31:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1004211024290.1728-100000@iolanthe.rowland.org>
References: <19701.42333.qm@web31803.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <19701.42333.qm@web31803.mail.mud.yahoo.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Jonas Schwertfeger <jschwertfeger@gmail.com>, Dinh.Nguyen@freescale.com, Mark Lord <mlord@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 21 Apr 2010, Luben Tuikov wrote:

> > > The real problem with the Buffalo drive is that it
> > responds with a
> > > phase error when it receives an ATA_16 IDENTIFY DEVICE
> > command with the
> > > Sector Count field set to 0.
> 
> The Sector Count field in the ATA PASS-THROUGH (12) or (16) CDB
> should be set appropriately by the Application Client as the neither
> the SAT bridge nor the SATA transport will interpret the ATA Command
> byte. Thus, for IDENTIFY (PACKET) DEVICE the Application Client
> should set it to 1.

Why do you say that 1 is the appropriate value?  In the ATA-5 spec
(which is the most recent version I have) Sector Count is listed as
"na" for IDENTIFY DEVICE, which means that the content of that field is
not applicable to this particular command.  Hence the value shouldn't 
matter.

Alan Stern

