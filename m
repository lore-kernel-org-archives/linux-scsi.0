From: Luben Tuikov <luben@splentec.com>
Subject: Q: calling SCpnt->scsi_done() on cancelled commands?
Date: Fri, 21 Jun 2002 23:03:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D13E91C.4E7BD549@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g5M33t406541
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jun 2002 23:03:55 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

It was recently mentioned that calling scsi_done()
for cancelled commands doesn't matter.

I'd like to inquire as the the future of this
condition?

I also noticed that aic7xxx also calls
scsi_done() on cancelled commands (by the mid-layer,
or otherwise).

In my code, I don't always know how the command was
cancelled, it may have been cancelled by the middle
layer or by other sources/means -- whenever this
happens I just set a flag and let ``the command movers''
(from queue to queue) actually cancel the command
(set the result code, if scsi_done() call scsi_done()
and release the command to the mid-layer).

What is the future of calling scsi_done() on
cancelled by the mid-layer commands?

TIA,
-- 
Luben
