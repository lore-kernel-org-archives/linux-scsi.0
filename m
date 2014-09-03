From: worley@alum.mit.edu (Dale R. Worley)
Subject: Re: Problem with USB-to-SATA adapters (was: AS2105-based enclosure
 size issues with >2TB HDDs)
Date: Wed, 3 Sep 2014 15:50:16 -0400
Message-ID: <201409031950.s83JoGxU015055@hobgoblin.ariadne.com>
References: <Pine.LNX.4.44L0.1409031459400.2156-100000@iolanthe.rowland.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qmta06.westchester.pa.mail.comcast.net ([76.96.62.56]:57710
	"EHLO qmta06.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544AbaICTuT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 15:50:19 -0400
In-reply-to: <Pine.LNX.4.44L0.1409031459400.2156-100000@iolanthe.rowland.org>
	(stern@rowland.harvard.edu)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

> From: Alan Stern <stern@rowland.harvard.edu>

> Anyway, I can try writing a patch to add this capability.  We'll see if 
> it can solve your problem.

Unfortunately, I think there is genuine value in such a hack.  E.g.,
I've got two USB-to-SATA adapters.  One works correctly.  One does
not.  But at this point, I can't attach both of my high-capacity disks
to the laptop at the same time, which makes it difficult to
bulk-transfer files from one to the other.

If, for the deficient adapter, the kernel assumed the disk size was
the end of the last partition (or the backup GPT partition table, if
that follows), then I could use it for everything other than
repartitioning.  And that would make life easier.

Thanks for trying,

Dale
