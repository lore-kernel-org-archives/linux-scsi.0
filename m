From: David Brownell <david-b@pacbell.net>
Subject: Re: driverfs is not for everything! (was:  [PATCH] /proc/scsi/map)
Date: Sun, 23 Jun 2002 18:34:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D16771E.2010401@pacbell.net>
References: <59885C5E3098D511AD690002A5072D3C02AB7F52@orsmsx111.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "Grover, Andrew" <andrew.grover@intel.com>
Cc: 'Nick Bellinger' <nickb@attheoffice.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>

> Is the device PHYSICALLY hooked up to the computer? If not, it shouldn't be
> in devicefs.

What's "devicefs" -- some new filesystem?  Or a mis/re-naming of "driverfs"?
I assume you don't mean "devfs".


> The device tree (for which devicefs is the fs representation) was originally
> meant to enable good device power management and configuration. 

Surely a driver using IP-over-wire like iSCSI is no less deserving of appearing
in "driverfs" than one whose driver uses custom-protocol-over-a-"wire" like USB,
FireWire, FC, IR, SCSI, or Bluetooth?  I don't see why some disks (for example)
should deserve to be "more equal than others" -- and approved to be in driverfs.

Admittedly some of those may have few power management concerns beyond basic
startup/shutdown sequencing.  But the configuration management issues won't
go away just because a driver talks to a device over some more generalized
notion of wire.  I suspect those are probably more important, long-term, than
the power management hooks.  I seem to recall other operating systems starting
out with a device/driver tree well before power management existed, and was
surprised when I noticed Linux didn't have one yet.

No, of course driverfs isn't for everything.  But if it's not for all drivers,
then what's it for -- just power management?

- Dave

