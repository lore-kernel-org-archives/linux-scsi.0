From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 17 Jan 2003 10:06:08 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0301171003110.739-100000@ida.rowland.org>
References: <200301171155.36452.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200301171155.36452.oliver@neukum.name>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Mike Anderson <andmike@us.ibm.com>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

On Fri, 17 Jan 2003, Oliver Neukum wrote:

> Am Freitag, 17. Januar 2003 09:50 schrieb Mike Anderson:
> >
> > If the device disappears the host needs to return all IOs in flight with
> > an error, and  we need to ensure new ones do not start ( setting the
> > device offline and maybe host_self_blocked). This is a start on getting
> > the scsi_remove_host to succed.
> 
> Could you provide some details?

Usb-storage does most of this already.  When the device is unplugged, 
all current transactions return an error and any new ones return a 
device-not-ready code.  But that doesn't solve the problem of removing the 
device's representation within SCSI and sysfs.

Alan Stern

