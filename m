From: greg kh <gregkh@us.ibm.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Thu, 16 Jan 2003 12:43:47 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <b075fh$phv$1@main.gmane.org>
References: <10426732153816@kroah.com> <20030116173539.GA31235@kroah.com> <20030116114323.C29001@one-eyed-alien.net> <20030116195306.GA32697@kroah.com> <b073ja$12i$1@penguin.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from root by main.gmane.org with local (Exim 3.35 #1 (Debian))
	id 18ZIq8-0007Kk-00
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2003 23:50:24 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-usb-devel@lists.sourceforge.net

Copied to linux-usb-devel, as they should also see this...

On Thu, 16 Jan 2003 12:10:18 -0800, Linus Torvalds wrote:

> In article <20030116195306.GA32697@kroah.com>, Greg KH  <greg@kroah.com>
> wrote:
>>On Thu, Jan 16, 2003 at 11:43:23AM -0800, Matthew Dharm wrote:
>>> Well, we only create the host when the device is first attached. After
>>> that, if it goes away and comes back, we re-connect it to the old SCSI
>>> host.
>>
>>Ick, so when the device is gone, where does the SCSI host go?  Is it
>>still represented in sysfs and in the SCSI core properly?
> 
> This is pure and utter USB storage stupidity, and nothing else.
> 
> When the USB storage device is unplugged, the device should be
> unregistered.  It should be _gone_.  It isn't sleeping, it's dead.  It's
> an ex-device.

Agreed, I thought most of that logic had been removed from the
usb-storage driver as the SCSI layer can now handle removing devices just
fine (or so Mike Anderson tells me :)

thanks,

greg k-h

