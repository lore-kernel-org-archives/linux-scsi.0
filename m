From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Thu, 16 Jan 2003 12:48:18 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030116204818.GC1137@beaverton.ibm.com>
References: <10426732153816@kroah.com> <10426732212871@kroah.com> <20030116093112.B29001@one-eyed-alien.net> <20030116173539.GA31235@kroah.com> <20030116114323.C29001@one-eyed-alien.net> <20030116195306.GA32697@kroah.com> <3E2718A0.5020905@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E2718A0.5020905@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

David Brownell [david-b@pacbell.net] wrote:
> Have any of the SCSI people been looking much at SCSI hotplug on 2.5?
> I attach "/etc/hotplug/scsi.agent" from one of my desktops; all it
> does is make sure the right drivers are loaded, it doesn't have a
> clue yet about whether/how/where to mount disks or do other stuff.

SCSI has added newer interfaces for host drivers to use that allow
single adds and removes. The api document is located in
/Documentation/scsi/scsi_mid_low_api.txt. I believe it is fairly
current.

I have been using the scsi_debug driver (which uses the newer interface)
to add and remove pseudo adapters, but have not checked the results
through user space hotplug.

-andmike
--
Michael Anderson
andmike@us.ibm.com

