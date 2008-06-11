From: Greg KH <greg@kroah.com>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Wed, 11 Jun 2008 12:15:33 -0700
Message-ID: <20080611191533.GA6189@kroah.com>
References: <200806010415.05290.chris2553@googlemail.com> <1212950276.3574.7.camel@localhost.localdomain> <200806102206.26818.chris2553@googlemail.com> <200806111858.05114.chris2553@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762671AbYFKTRQ@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200806111858.05114.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Clayton <chris2553@googlemail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 11, 2008 at 06:58:05PM +0000, Chris Clayton wrote:
> Jun 11 17:48:13 upstairs udevd-event[1457]: wait_for_sysfs: wait for '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/ioerr_cnt' for 20 mseconds 
> Jun 11 17:48:18 upstairs last message repeated 236 times

This doesn't look good.  It looks like a udev rule in your system is
looking for a file that will never show up.  That's a short way to a
long delay time :)

Try commenting out the rule that does this and see if things are fixed.

thanks,

greg k-h
