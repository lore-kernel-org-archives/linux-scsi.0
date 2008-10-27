From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: usb hdd problems with 2.6.27.2
Date: Mon, 27 Oct 2008 10:33:12 -0500
Message-ID: <1225121592.5146.9.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0810271117530.4059-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753266AbYJ0Pdd@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0810271117530.4059-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Luciano Rocha <luciano@eurotux.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Linux-Kernel <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-10-27 at 11:25 -0400, Alan Stern wrote:
> On Mon, 27 Oct 2008, Douglas Gilbert wrote:
> > BTW a single disk in RAID 0 (seen on a HP E200 controller)
> > has a shortened capacity value seen in the midlevel on the
> > corresponding logical drive. That missing chunk is probably
> > where the RAID controller puts its control information.
> > Anyway, playing with the capacity value returned by READ
> > CAPACITY certainly has a precedent.
> 
> usb-storage isn't in the business of altering the data it gets from a 
> device.  It's just a transport.  That's why the sdev->fix_capacity flag 
> exists; we tell the upper layer that the data it gets is going to be 
> wrong and let the upper layer worry about fixing things up.

And you do this by setting US_FL_FIX_CAPACITY in unusual_devs.h

James
