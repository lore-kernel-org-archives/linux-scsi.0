From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: New Methodology for SCSI BK trees
Date: 24 Oct 2004 15:56:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098647814.10908.244.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:2529 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261235AbUJXT5F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2004 15:57:05 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dougg@torque.net>, viro@parcelfarce.linux.theplanet.co.uk

OK, since we're going to be doing another round of
-rc-but-I-dont-really-mean-it, I've set up two scsi bk trees.

bk://linux-scsi.bkbits.net/scsi-rc-fixes-2.6

for fixes which I'll try and merge into -rc candidates

and

bk://linux-scsi.bkbits.net/scsi-misc-2.6

for everything else that will wait until 2.6.10 is released.

Andrew, could you add both these to -mm, please?

For the rc-fixes tree, I'm going to try to guess when linus moves to
-rc-and-I-really-mean-it and at that point I'll only accept critical bug
fixes into this tree (probably I'll tighten up submission policy
gradually as time goes by).

Also, I've gained a web page at

http://www.parisc-linux.org/~jejb/scsi_diffs

Where I'll place the diffs and changelogs corresponding to the scsi
trees for those who want to play with the updates without using BK.

James


