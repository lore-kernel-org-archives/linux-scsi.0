From: Chris Clayton <chris2553@googlemail.com>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Fri, 6 Jun 2008 17:42:53 +0000
Message-ID: <200806061742.53204.chris2553@googlemail.com>
References: <200806010415.05290.chris2553@googlemail.com> <1212761485.3466.6.camel@localhost.localdomain> <200806061642.07563.rjw@sisk.pl>
Reply-To: chris2553@googlemail.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:5982 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbYFFRp1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 13:45:27 -0400
Received: by ug-out-1314.google.com with SMTP id h2so747937ugf.16
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jun 2008 10:45:26 -0700 (PDT)
In-Reply-To: <200806061642.07563.rjw@sisk.pl>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

On Friday 06 June 2008, Rafael J. Wysocki wrote:
> On Friday, 6 of June 2008, James Bottomley wrote:
> > On Fri, 2008-06-06 at 06:07 +0000, Chris Clayton wrote:
> > > On Friday 06 June 2008, Andrew Morton wrote:
> > > > On Sun, 1 Jun 2008 04:15:05 +0000 Chris Clayton
> > > > <chris2553@googlemail.com>
> > >
> > > wrote:
> > > > > Hi,
> > > > >
> > > > > I've just started testing 2.6.26 on my desktop machine and have
> > > > > found that I get a long pause (20 seconds or so) as the system
> > > > > boots. By pause I mean that the boot messages that normally scroll
> > > > > by stop doing so for, as I say, about 20 seconds.
> > > > >
> > > > > I've done a bisect and arrived at:
> > > > >
> > > > > b0ed43360fdca227048d88a08290365cb681c1a8 is first bad commit
> > > > > commit b0ed43360fdca227048d88a08290365cb681c1a8
> > > > > Author: Hannes Reinecke <hare@suse.de>
> > > > > Date:   Tue Mar 18 14:32:28 2008 +0100
> > > > >
> > > > >     [SCSI] add scsi_host and scsi_target to scsi_bus
> > > > >
> > > > >     This patch implements scsi_host and scsi_target device types
> > > > >     and adds both to the scsi_bus.
> > > > >
> > > > >     Signed-off-by: Hannes Reinecke <hare@suse.de>
> > > > >     Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > > > >     Signed-off-by: James Bottomley
> > > > > <James.Bottomley@HansenPartnership.com>
> > > > >
> > > > > :040000 040000 4e3140909966b4c9aa987d34ee4078d283fe0351
> > > > >
> > > > > 46e4fd28cc537ba700eb4f5652abf043fed4d76d M      drivers
> > > > >
> > > > > The config file for that kernel is attached as are the kernel log
> > > > > for booting that kernel and the bisect log.
> > > > >
> > > > > I've also noticed that it takes much longer for icons to appear on
> > > > > my desktop when I plug a usb storage device in. (The icons are
> > > > > shown/hidden by a simple sctript that is run via udev when the
> > > > > device is attached/detached.)
> > > >
> > > > Do you believe that this is the same period?  20 seconds?
> > >
> > > Thanks for the reply, Andrew. I was beginning to think that I'd
> > > committed an LKML sin :-)
> > >
> > > Yes, it is about the same. On 2.6.25.4 (and earlier), the icons appear
> > > within a second or two, but with 2.6.26-rc2 or later, it takes about 20
> > > seconds. I've now built and installed -rc5 and am seeing the same
> > > behaviour.
> > >
> > > I've also built -rc5 on my laptop. On that my kernel uses the older IDE
> > > drivers rather than libata. The boot proceeds with no pause, but I do
> > > see the same delay in the desktop icons appearing when I attach a
> > > usb-storage device.
> > >
> > > > > Let me know of any way I can help solve this.
> > > > >
> > > > > Please cc me to any reply as I'm not subscribed.
> > > >
> > > > cc's added.
> > > >
> > > > Rafael, we might need to track this as a post-2.6.26 regression.
> >
> > It already is ... as I asked in the actual bug (but no-one seems to have
> > noticed, so I assume the bug entry isn't set up correctly).
>
> The bug reporter has no Bugzilla account, so I couldn't add him to the CC
> list of the bug.
>

I do have a bugzilla account, but for some reason I couldn't log in to it to 
report this bug, so I mailed LKML to get the ball rolling. I can now log in so 
I've added myself to the CC list.

Thanks.
> Thanks,
> Rafael



-- 
Beauty is in the eye of the beerholder.
