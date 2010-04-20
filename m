From: Mark Lord <mlord@pobox.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Mon, 19 Apr 2010 20:25:59 -0400
Message-ID: <4BCCF497.70504@pobox.com>
References: <20100416182026.GA10023@xanatos>
 <Pine.LNX.4.44L0.1004161517260.1923-100000@iolanthe.rowland.org>
 <20100419211539.GB4245@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <20100419211539.GB4245@xanatos>
Sender: linux-hotplug-owner@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jonas Schwertfeger <jschwertfeger@gmail.com>, Dinh.Nguyen@freescale.com, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On 19/04/10 05:15 PM, Sarah Sharp wrote:
> Updated description
> -------------------
>
> Summary:
>
> The Buffalo USB3 hard drive fails to mount after being sent an ATA_16
> IDENTIFY command.  It does not fail when the device is connected via a
> USB 2.0 cable and the same command is sent.
>
> Details:
>
> There seems to be an issue with how the Buffalo USB3 hard drive handles
> the SCSI ATA pass through commands.  We found this issue with the Linux
> userspace program hdparm, using the Ubuntu Linux Karmic distribution.
> The device responds correctly to an IDENTIFY DEVICE via the ATA_12
> tunnel, but it responds with a Phase Error when it's sent an IDENTIFY
> DEVICE via the ATA_16 tunnel, and then stalls.
..

I hsven't gone away or anything -- still reading mostly every word of this thread.
I haven't done anything further here because I really don't understand
the whole story.  Sarah's latest summary (above) helps a lot, though.

But I'm not sure what, if anything I (hdparm) can do differently to help here.

Can anyone out there send me one of these gadgets?

Oh wait.. that wouldn't be terribly useful, I suppose,
since I also don't have any newfangled USB3 host gear.

Suggestions?
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
