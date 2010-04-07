From: Jerone Young <jerone.young@canonical.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 07 Apr 2010 09:51:58 -0500
Message-ID: <1270651918.1583.4.camel@laptop>
References: <Pine.LNX.4.44L0.1004071032500.1779-100000@iolanthe.rowland.org>
	 <4BBC99ED.30306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <4BBC99ED.30306@gmail.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Jonas Schwertfeger <jschwertfeger@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Mark Lord <mlord@pobox.com>, dgilbert@interlog.com, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>
List-Id: linux-scsi@vger.kernel.org

Hey guys,

	We are seeing the same issue with firewire & some USB 2.0 drives as
well. We are trying to figure out a good work around or fix. Tracking
here:
https://bugs.launchpad.net/oem-priority/+bug/515023
and 
https://bugs.launchpad.net/oem-priority/+bug/548513

					Thanks,
						Jerone


On Wed, 2010-04-07 at 16:42 +0200, Jonas Schwertfeger wrote:
> On 04/07/2010 04:36 PM, Alan Stern wrote:
> > This is not what I expected.  What version of the kernel are you using?
> > Those 'Z' entries should not be possible in 2.6.33 or later.
> 
> I'm not using a 2.6.33 kernel. I'm using 2.6.32 (which is going to be 
> the mainline version for Ubuntu 10.04 LTS, which is being released at 
> the end of April).
> 
> -Jonas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-hotplug" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


