From: Bryan Henderson <hbryan@us.ibm.com>
Subject: RE: A different look at block device hotswap in the Linux kernel
Date: Fri, 24 Jan 2003 10:01:28 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF73A095F7.76CA02FF-ON87256CB8.0060AF6A-88256CB8.006323FB@us.ibm.com>
References: <A5974D8E5F98D511BB910002A50A66470580D59C@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <A5974D8E5F98D511BB910002A50A66470580D59C@hdsmsx103.hd.intel.com>
List-Id: linux-scsi@vger.kernel.org
To: "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: andmike@us.ibm.com, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, Linux SCSI list <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, Luben Tuikov <luben@splentec.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, "'mjacob@feral.com'" <mjacob@feral.com>, Oliver Neukum <oliver@neukum.name>, Steven Dake <sdake@mvista.com>, Alan Stern <stern@rowland.harvard.edu>





>The comparing of a saved device list snapshot with the current device
should
>be the responsibility of

>From a usability standpoint, I don't think any such comparing should be
done by anyone.  When I unplug a device and then plug it in again, I want a
total reset.  I'm willing to take my lumps if I unplug something that isn't
in a state to be safely unplugged.

It's like when I pull the power plug because my system is totally hosed and
I want to start over.  I know I can cause damage by doing that, but I would
be upset if the new system booted back to the broken state it was in when I
unplugged it.

