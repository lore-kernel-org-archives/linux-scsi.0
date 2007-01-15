From: Bjarne Thomsen <bjarne.thomsen@get2net.dk>
Subject: Re: [Fwd: Re: aic79xx+ASC39320A crash]
Date: Mon, 15 Jan 2007 20:24:04 +0100
Message-ID: <1168889044.9588.16.camel@tycho.astronomy.dk>
References: <1167639505.27998.25.camel@home-desk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailfe07.tele2.dk ([212.247.154.195]:40699 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751416AbXAOTYL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jan 2007 14:24:11 -0500
Received: from [83.72.33.52] (account mp56609@get2net.dk HELO tycho.astronomy.dk)
  by mailfe07.swip.net (CommuniGate Pro SMTP 5.0.12)
  with ESMTPA id 385264814 for linux-scsi@vger.kernel.org; Mon, 15 Jan 2007 20:24:05 +0100
In-Reply-To: <1167639505.27998.25.camel@home-desk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Mon, 2007-01-01 at 00:18 -0800, Sean Bruno wrote:
> email message attachment, "Forwarded message - Re: aic79xx+ASC39320A
> crash"
> > -------- Forwarded Message --------
> > From: Bjarne Thomsen <bjarne.thomsen@get2net.dk>
> > To: Sean Bruno <sean.bruno@dsl-only.net>
> > Subject: Re: aic79xx+ASC39320A crash
> > Date: Mon, 01 Jan 2007 09:12:16 +0100 
> > 
> > On Sun, 2006-12-31 at 11:29 -0800, Sean Bruno wrote:
> > > On Sun, 2006-12-31 at 11:07 +0100, Bjarne Thomsen wrote: 
> > > > The symptom is the same: the system freezes during the copy
> > > > of files from an IDE harddisk to a SCSI disk on the 39320 controller.
> > > 
> > > Is there any crash dump or panic information on your screen?
> > >  
> > > Sean
> > > 
> > There is no crash dump or panic information.
> > The keyboard and mouse are dead.
> > Only the reset button works.
> > 
> > I tried to reset the 39320A BIOS to its default values.
> > The result of a cp from the IDE drive to the SCSI drive
> > was again a crash without a trace in the syslog file,
> > or on the screen.

Something else has happened. This time the partition table
seemed to have been currupted. I could not write a new
partition table to the IDE disk. fdisk kept showing no
partitions on /dev/hda.
Then I had the idea to load the BIOS defaults for the MB,
and I could suddenly see all partitions on /dev/hda with fdisk.
To me it looks as if some parts of the BIOS of the main board
has been overwritten (by the aic79xx driver?).
The main board is a Tyan 2885 with 1 GB of RAM.

 -- Bjarne


