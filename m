From: Matthew Jacob <mjacob@feral.com>
Subject: RE: A different look at block device hotswap in the Linux kernel
Date: Fri, 24 Jan 2003 10:09:32 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030124100832.Y1605-100000@wonky.in0.lcl>
References: <OF73A095F7.76CA02FF-ON87256CB8.0060AF6A-88256CB8.006323FB@us.ibm.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <OF73A095F7.76CA02FF-ON87256CB8.0060AF6A-88256CB8.006323FB@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: "Cress, Andrew R" <andrew.r.cress@intel.com>, andmike@us.ibm.com, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, Linux SCSI list <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, Luben Tuikov <luben@splentec.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.name>, Steven Dake <sdake@mvista.com>, Alan Stern <stern@rowland.harvard.edu>

>
> It's like when I pull the power plug because my system is totally hosed and
> I want to start over.  I know I can cause damage by doing that, but I would
> be upset if the new system booted back to the broken state it was in when I
> unplugged it.

I had this conversation with doug offlist- this is a policy choice. You
may want your device to reattach as totally new. You may, on the other
hand, want your device to resume where you left off. I can see valid
reasons for wanting either behaviour (but it can't/shouldn't be deduced
by the OS).


