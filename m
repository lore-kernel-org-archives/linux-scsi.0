From: Patrick Mochel <mochel@osdl.org>
Subject: Re: driverfs is not for everything! (was:  [PATCH] /proc/scsi/map)
Date: Tue, 25 Jun 2002 11:18:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0206251115340.8496-100000@geena.pdx.osdl.net>
References: <59885C5E3098D511AD690002A5072D3C02AB7F52@orsmsx111.jf.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <59885C5E3098D511AD690002A5072D3C02AB7F52@orsmsx111.jf.intel.com>
List-Id: linux-scsi@vger.kernel.org
To: "Grover, Andrew" <andrew.grover@intel.com>
Cc: 'Nick Bellinger' <nickb@attheoffice.org>, David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


> Is the device PHYSICALLY hooked up to the computer? If not, it shouldn't be
> in devicefs.

But, it should be in driverfs. I'll let the devicefs people decide what to 
do ;)

> The device tree (for which devicefs is the fs representation) was originally
> meant to enable good device power management and configuration. driverfs
> wasn't meant to handle iscsi or tcpip (that is, network) connections, nor
> should it have to.

Both statements are entirely true. driverfs doesn't care about device
types. The only thing the filesystem does is export the kernel data
structures and the relationships between them.

But, those devices are physical devices that the kernel is communicating 
with. Which is exactly what the device tree was designed to do.

	-pat

