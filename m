From: Patrick Mochel <mochel@osdl.org>
Subject: Re: driverfs bus_id, name (was: [PATCH] /proc/scsi/map)
Date: Tue, 25 Jun 2002 12:06:14 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0206251159040.8496-100000@geena.pdx.osdl.net>
References: <3D18AC9B.8050306@pacbell.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D18AC9B.8050306@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Nick Bellinger <nickb@attheoffice.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


> I've been wondering about that.  Right now PCI and USB both use fairly
> unfriendly/unpretty values in device.name ... "{PCI,USB} device VVVV:PPPP".
> 
> Let me make sure I understand you right here, by examples of two
> changes I'd like to see.  Correct me if these seem wrong:
> 
> - It'd be more appropriate for PCI devices to copy pci_device.name into
>    device.name and get the user-friendly names from the PCI device name
>    database (when available), and only fallback to those nasty strings
>    when the more user-friendly names aren't available.

That is what happens with PCI devices. They're not appearing as meaningful 
names probably because CONFIG_PCI_NAMES isn't set. Whether or not that 
information belongs in the kernel is another debate. 

I believe the SCSI people mentioned something about being able to set 
those from userspace. I'm not opposed to such an idea. You just need a 
writable name file. 

> - Likewise it'd be more appropriate for USB devices to take the
>    descriptive strings from the devices, like "Philips USB Digital
>    Speaker System", than "USB device 0471:0104".

Those are in the devices themselves, right? There is nothing stopping the 
USB people from doing that... ;)

	-pat

