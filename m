From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 3.16.2: 2TiB Seagate Expansion Desk apparently still broken with
 both USB mass storage *and* UAS: some debugging output
Date: Sun, 7 Sep 2014 16:03:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1409071555010.404-100000@netrider.rowland.org>
References: <8738c3uxk0.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8738c3uxk0.fsf@spindle.srvr.nix>
Sender: linux-kernel-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexandre Oliva <oliva@gnu.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 7 Sep 2014, Nix wrote:

> I have a brand new Seagate Expansion Desk drive attached to my x86-64
> desktop. (I also have a 4TiB model of the same drive, but I haven't even
> unboxed it: there seems little point as long as the 2TiB version doesn't
> work.) I am seeing apparently the same problem as Alexandre Oliva
> reported in <https://bugzilla.kernel.org/show_bug.cgi?id=79511>. The
> drive is USB ID 0bc2:3321, so probably a slightly different model than
> Alexandre's 0bc2:3320, but similar enough to be broken it seems.
> 
> I've tried it with both the usb-storage driver on xhci and with UAS,
> with verbose USB mass storage debugging turned on. Both fail with
> different log messages: see below. I haven't tried Alexandre's quirk
> yet. (I have USB debugging for the UAS case only, alas, because the
> system helpfully autoloaded and used that module when I was trying to
> replicate the usb-storage-only failure, sigh. Autoloading is annoying
> sometimes! :) )

...

> I'm happy to do whatever further debugging people may deem necessary:
> this system has up-to-date backups and is easy to reboot and try new
> kernels on, and the drive is brand new and completely empty so it's
> pretty much impossible to mess up!

Please post a usbmon trace showing what happens when the drive binds to 
usb-storage.  To prevent extraneous data from cluttering the trace, you 
should unplug as many of the other USB devices on the same bus as 
possible before starting the trace.

Alan Stern
