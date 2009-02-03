From: Sean Bruno <sean.bruno@dsl-only.net>
Subject: Re: SMART Status Query
Date: Tue, 03 Feb 2009 06:22:56 -0800
Message-ID: <1233670976.2065.1.camel@localhost.localdomain>
References: <1233643011.8067.21.camel@localhost.localdomain>
	 <4987FB23.7040600@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 069-064-224-068.pdx.net ([69.64.224.68]:51963 "EHLO
	iron2.pdx.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751761AbZBCO3i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2009 09:29:38 -0500
In-Reply-To: <4987FB23.7040600@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Tue, 2009-02-03 at 09:06 +0100, Stefan Richter wrote:
> (Cc'd LSML in case I write nonsense)
> 
> Sean Bruno wrote:
> > Out of curiosity, I tried to query the smart status from disks in a
> > FW400 enclosure.  I was prompted that the drives do not support SMART.
> > 
> > The Seagates in the enclosure do indeed support SMART and I suppose that
> > there is a missing bit in the firewire stack or in my enclosure that
> > would allow these commands to be passed down to the disks.
> > 
> > Does this situation have a resolution?  Is there a way around it?
> > 
> > I do find it interesting, that the the actual disk information is
> > returned and not the "spoofed" enclosure disk names.
> > 
> > I tried "smartctl -a /dev/sdd" and was presented with:
> > [sean@home-desk ~]$ sudo smartctl -a /dev/sdc
> > smartctl version 5.38 [x86_64-redhat-linux-gnu] Copyright (C) 2002-8
> > Bruce Allen
> > Home page is http://smartmontools.sourceforge.net/
> > 
> > Device: ST380811 AS               Version: 3.AA
> > Serial number:             5PS13NWB
> > Device type: disk
> > Local Time is: Mon Feb  2 22:36:07 2009 PST
> > Device does not support SMART
> > 
> > Error Counter logging not supported
> > Device does not support Self Test logging
> 
> AFAIK SMART requires "ATA pass-through", i.e. the tunneling of ATA
> commands through SCSI.
> 
> The FireWire drivers happily send any command to the target which the
> Linux kernel or an application emits.  The missing piece here is ATA
> pass-through support in the firmware of the FireWire-to-SATA bridge chip
> of the drive enclosure.
> 
> I have not yet heard of FireWire-to-SATA bridges which do support ATA
> pass-through.

That makes sense, unfortunate, but not unexpected.

Can you tell me how my system is getting the Seagate drive information
then?  I've looked over the data available to me on the Firewire bus,
and don't see where it's being pulled from.

Sean

