From: "Grover, Andrew" <andrew.grover@intel.com>
Subject: RE: driverfs is not for everything! (was:  [PATCH] /proc/scsi/map
	 )
Date: Mon, 24 Jun 2002 11:47:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <59885C5E3098D511AD690002A5072D3C02AB7F56@orsmsx111.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Roman Zippel' <zippel@linux-m68k.org>
Cc: 'David Brownell' <david-b@pacbell.net>, 'Nick Bellinger' <nickb@attheoffice.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>

> From: Roman Zippel [mailto:zippel@linux-m68k.org] 
> On Mon, 24 Jun 2002, Grover, Andrew wrote:
> > If a device can be accessed by multiple machines 
> concurrently, it should not
> > be in driverfs.
> 
> I don't think it's that easy. If the computer wakes up again, 
> devices have
> to be reinitialised in the right order, e.g. iSCSI needs a 
> working network
> stack and devices.

Would the iSCSI device be a child of the network device? That would ensure
that the NIC was fully restarted before the iSCSI device.

> Another problem is how to properly shutdown the
> machine. Scripts now "know" that nfs requires the network, 
> but how does
> the script find out, that /dev/sdb2 is an iSCSI device, so that it can
> properly unmount the device, before the network is shutdown?

Would a bottom-up traversal of the device tree do things properly?

Regards -- Andy
