From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 7 Apr 2010 11:03:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1004071101560.1779-100000@iolanthe.rowland.org>
References: <4BBC99ED.30306@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <4BBC99ED.30306@gmail.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Jonas Schwertfeger <jschwertfeger@gmail.com>
Cc: Mark Lord <mlord@pobox.com>, dgilbert@interlog.com, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>
List-Id: linux-scsi@vger.kernel.org

On Wed, 7 Apr 2010, Jonas Schwertfeger wrote:

> On 04/07/2010 04:36 PM, Alan Stern wrote:
> > This is not what I expected.  What version of the kernel are you using?
> > Those 'Z' entries should not be possible in 2.6.33 or later.
> 
> I'm not using a 2.6.33 kernel. I'm using 2.6.32 (which is going to be 
> the mainline version for Ubuntu 10.04 LTS, which is being released at 
> the end of April).

In that case, can you repeat the test using an EHCI controller instead 
of xHCI?

Alan Stern

