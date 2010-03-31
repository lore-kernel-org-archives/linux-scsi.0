From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 31 Mar 2010 10:56:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1003311054500.1739-100000@iolanthe.rowland.org>
References: <h2n59ca64281003310439z2f317661xf1d501a5f21c64b3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <h2n59ca64281003310439z2f317661xf1d501a5f21c64b3@mail.gmail.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Jonas Schwertfeger <jschwertfeger@gmail.com>
Cc: linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, dgilbert@interlog.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 31 Mar 2010, Jonas Schwertfeger wrote:

> Since this seems to have become a udev issue I'm brining the
> hotplug/udev list into the loop.
> 
> A brief recap for the hotplug list readers: I'm experiencing issues
> with a USB 3.0 hard drive (Buffalo HD-HXU3) on kernel 2.6.32.9 with
> udev 151. When connected the device seems to be recognized and
> registered with xHCI and USB core correctly but then responds to a
> bulk transfer with a stall. We narrowed the issue down to udev by
> stopping the udev daemon, connecting the device and mounting it
> manually. If done this way the drive works fine. However, if udevd is
> running the device stalls. Below is an excerpt of the conversation
> involving the USB core, the USB storage and the SCSI list.
> 
> Any idea what command (most likely coming from udev) could cause the
> drive to stall and what could be done about it?

More specifically, what program issues ATA-passthrough commands?  And 
what can be done to prevent it from doing so in cases where these 
commands cause the device to crash?

Alan Stern

