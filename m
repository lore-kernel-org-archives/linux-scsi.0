From: Roman Zippel <zippel@linux-m68k.org>
Subject: RE: driverfs is not for everything! (was:  [PATCH] /proc/scsi/map
 )
Date: Mon, 24 Jun 2002 20:32:15 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0206242017140.8911-100000@serv>
References: <59885C5E3098D511AD690002A5072D3C02AB7F53@orsmsx111.jf.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <59885C5E3098D511AD690002A5072D3C02AB7F53@orsmsx111.jf.intel.com>
List-Id: linux-scsi@vger.kernel.org
To: "Grover, Andrew" <andrew.grover@intel.com>
Cc: 'David Brownell' <david-b@pacbell.net>, 'Nick Bellinger' <nickb@attheoffice.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>

Hi,

On Mon, 24 Jun 2002, Grover, Andrew wrote:

> With technologies like USB, infiniband, NFS, iSCSI, and 1394, it's tough,
> but the main question should be:
>
> "If my computer suspends, should this device be turned off?" Which is
> another way of asking is the use of a device exclusive to a particular
> machine.
>
> If a device can be accessed by multiple machines concurrently, it should not
> be in driverfs.

I don't think it's that easy. If the computer wakes up again, devices have
to be reinitialised in the right order, e.g. iSCSI needs a working network
stack and devices. Another problem is how to properly shutdown the
machine. Scripts now "know" that nfs requires the network, but how does
the script find out, that /dev/sdb2 is an iSCSI device, so that it can
properly unmount the device, before the network is shutdown?

bye, Roman

