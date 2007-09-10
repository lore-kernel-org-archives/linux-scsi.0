From: Rene Herman <rene.herman@gmail.com>
Subject: Re: sata & scsi suggestion for make menuconfig
Date: Mon, 10 Sep 2007 14:43:44 +0200
Message-ID: <46E53C00.6060107@gmail.com>
References: <20070907124800.GP16806@vanheusden.com>	 <p73fy1p9m57.fsf@bingen.suse.de>	 <1189371621.3526.28.camel@localhost.localdomain>	 <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org>	 <20070909212159.GF25798@one.firstfloor.org> <1189373951.3526.37.camel@localhost.localdomain> <46E4E64F.3070005@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:36023 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758879AbXIJMux (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2007 08:50:53 -0400
In-Reply-To: <46E4E64F.3070005@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andi Kleen <andi@firstfloor.org>, Jeff Garzik <jeff@garzik.org>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 09/10/2007 08:38 AM, Stefan Richter wrote:

> Nevertheless we should try to arrange the menus in a way that makes
> sense to as many people as possible.  The difficulty is, different
> environments call for different menu layouts, as your previous example
> of SATA DVD-only boxes demonstrates.
> 
> However, liberal usage of 'select' is not the ultimate solution to
> create menus that work for more people.  Just one problem with select is
> that it works behind the back of the people configuring kernels (unless
> they use an UI with debug options turned on) --- they have less control,
> they are less informed.  ATA already 'select's SCSI.  What do we gain
> from hiding the fact that Linux' SCSI option is not just for those
> 50-wire ribbons (which people still think SCSI stands for) but is a very
> central Linux subsystem for even more than what complies to the SCSI
> family of standards?
> 
> 'select' should really be limited to switch on small library-like code
> without further dependencies or requirements.  SCSI, together with its
> upper layer options, is not of this kind of library.
> 
> We should think about order and grouping of prompts and the labels of
> prompts (there were already suggestions in this discussion) before we
> resort to 'select' --- or even worse, select options unconditionally
> which are not always necessary to be enabled.
> 
> A pro pos grouping of options --- consider how options for another
> central subsystem are laid out:
> 
> 	Networking
> 		Networking options
> 			...
> 			TCP/IP networking
> 			...
> 		...
> 
> 	Device Drivers
> 		...
> 		Network device support
> 			...
> 			Ethernet (10 or 100MBit)
> 			...
> 		...
> 
> This also happens to reflect the layout of sources in directories, and
> the current SCSI menu layout is close to source layout too --- but it
> doesn't have to be that way.

If someone's keen on really restructuring these things -- in this analogy:

Storage
	Storage Options
		...
		Disk
		Optical
		...
	...

Device Drivers
	...
	Storage Support
		...
		IDE
		PATA
		SATA
		SCSI
		USB
		FW
		...
	...

(sound is an example where both in the menus and the tree everything is kept 
under one top-level sound/ directory, not sound/ and drivers/sound/ as for 
networking -- opinions may vary which one's better I guess).

This is just config menus -- on a source code level, it would also make 
sense at least at some point to introduce "storage/" alongside net/ and 
sound/ and move things around I guess.

Rene.

