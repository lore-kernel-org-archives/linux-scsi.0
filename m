From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Patch for iriver-mp3player
Date: 06 Jun 2004 09:48:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086533333.10787.45.camel@mulgrave>
References: <20040530014255.3876eea3.little.tobias@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:1235 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263702AbUFFOtV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Jun 2004 10:49:21 -0400
In-Reply-To: <20040530014255.3876eea3.little.tobias@gmx.de>
List-Id: linux-scsi@vger.kernel.org
To: Tobias Lieber <little.tobias@gmx.de>, Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-05-29 at 18:42, Tobias Lieber wrote:
> i Javier Marcet wrote in January 2004 a patch for linux-2.6.3, to make a i-River-mp3-Player mounting. It was on lkml: http://lkml.org/lkml/2004/1/6/170
> i was suprised, that it was not in the kernel, and no other soulution, too. So i read his patch for getting mouted the player, and rewrote it for linux-2.6.7-rc1-bk7. I attached it. It would be nice, if it would be possible mounting the mp3-player without patching the Kernel, so i would greet it, if this or an other solution woulg com into the Kernel.

Well, but the question is who gets to fix this?

Since this is a USB device returning broken inquiry data which sd then
acts on, I'd rather see USB fix it.

I cc'd the USB people.  Since you already do some scrubbing on the
inquiry data from this thing (to fix up the ANSI SCSI type), can't you
just add it as an unusual dev that needs the RMB bit resetting (and, if
that's so far wrong, probably other vital pieces of inquiry data as
well)?

James


