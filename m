From: Steven Dake <sdake@mvista.com>
Subject: Re: A different look at block device hotswap in the Linux kernel
Date: Thu, 23 Jan 2003 17:54:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E308EE1.9080208@mvista.com>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301231919.40422.oliver@neukum.name> <3E30538F.4080507@mvista.com> <200301240107.36977.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200301240107.36977.oliver@neukum.name>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>



>I want:
>LLDD to SCSI: device is gone
>SCSI to LLDD: Ok. I'll handle from here on.
>LLDD: OK. I am gone. And won't have any contact until the next device is
>plugged in.
>  
>
The downside of this approach is that the LLDD must now be able to 
detect insertions and removals when it may not be able to do so.  If it 
is able to do so, then fine, it can tell upper layers about it, but the 
actual control of removal of a device should occur higher up to fix 
several problems with the approach of having the LLDD manage the hotswap 
state of the device.

>The process can be somewhat more complicated, under some conditions:
>- it never fails
>- it is done within a finite, bounded, reasonable time
>
>	Regards
>		Oliver
>
>
>
>  
>

