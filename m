From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: dummy scsi read or scsi command periodically for external USB
 Hard Disk
Date: Wed, 9 Jul 2014 10:19:58 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1407091019030.873-100000@iolanthe.rowland.org>
References: <CANudz+vdVQAJgz1YYN=yFQn+749XFbvi3Hqnd+n5zkM5FxuJtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49012 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755249AbaGIOUA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2014 10:20:00 -0400
In-Reply-To: <CANudz+vdVQAJgz1YYN=yFQn+749XFbvi3Hqnd+n5zkM5FxuJtQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: loody <miloody@gmail.com>
Cc: "Bryn M. Reeves" <bmr@redhat.com>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 9 Jul 2014, loody wrote:

> on that usb hard disk, no matter media_change or TEST_UNIT_READY, keep
> polling the device every 3mins.
> the disconnection still happen.
> 
> So I am wondering, I can use the existence wheel, such as echo 40000 >
> /sys/block/sda/events_poll_
> msecs.
> but what it really do is read sector, not media_change or test_unit_ready.

No, you cannot change the event polling code.  Doing so would mess up 
other drives.

Alan Stern

