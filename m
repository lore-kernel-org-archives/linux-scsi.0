From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: dummy scsi read or scsi command periodically for external USB
 Hard Disk
Date: Mon, 7 Jul 2014 13:02:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1407071258360.871-100000@iolanthe.rowland.org>
References: <CANudz+vS1t3wWbEU6UGGKP=bb3KEvFcpmX=M2+ZnC8bxY_tPjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51983 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752575AbaGGRCN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2014 13:02:13 -0400
In-Reply-To: <CANudz+vS1t3wWbEU6UGGKP=bb3KEvFcpmX=M2+ZnC8bxY_tPjQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: loody <miloody@gmail.com>
Cc: "Bryn M. Reeves" <bmr@redhat.com>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 8 Jul 2014, loody wrote:

> > An alternative is to write a positive value, such as 240000, to
> >
> >         /sys/block/sdX/events_poll_msecs
> >
> > where X is replaced with the proper drive letter.  (240000 ms = 240 s =
> > 4 m.)  I'm not sure this will work, but it's worth a try.
> 
> I cannot find events_poll_msecs you mentioned in my system.
> Is this capability related to kernel version?
> ( my kernel version is 2.6.38.8 )

Well, the in-kernel disk events mechanism was added in 2.6.38, but it 
may not have been implemented for your type of drive.

Probably you don't actually need to do a read.  Simply opening the 
device file ought to be sufficient.

Alan Stern

