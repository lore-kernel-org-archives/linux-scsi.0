From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 17 Jan 2003 00:43:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301170043.36577.oliver@neukum.name>
References: <10426732153816@kroah.com> <3E2718A0.5020905@pacbell.net> <20030116204818.GC1137@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030116204818.GC1137@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>, David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Am Donnerstag, 16. Januar 2003 21:48 schrieb Mike Anderson:
> David Brownell [david-b@pacbell.net] wrote:
> > Have any of the SCSI people been looking much at SCSI hotplug on 2.5?
> > I attach "/etc/hotplug/scsi.agent" from one of my desktops; all it
> > does is make sure the right drivers are loaded, it doesn't have a
> > clue yet about whether/how/where to mount disks or do other stuff.
>
> SCSI has added newer interfaces for host drivers to use that allow
> single adds and removes. The api document is located in
> /Documentation/scsi/scsi_mid_low_api.txt. I believe it is fairly
> current.

This is good news in principle.
But what use is a function like scsi_remove_host() if it can fail?
If a device is gone, it is gone and all the complaining in the world
won't alter that.
Could you explain how a LLD can ensure that this function will always
succeed?

	Regards
		Oliver

