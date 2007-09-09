From: Matthew Wilcox <matthew@wil.cx>
Subject: [0/22] Advansys updates 2007-09-09
Date: Sun, 9 Sep 2007 08:53:58 -0600
Message-ID: <20070909145358.GG6809@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:59306 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbXIIOx7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 10:53:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here's another mammoth patch series for the advansys driver against
scsi-misc.  I've tested that it compiles at each stage and that the
final result works.

Some important parts to note:

1/22 Essential bugfix.  Please apply ASAP.
4/22 Reformat microcode.  Boring and large.
6,7,8,9/22 Remove internal queueing from driver
11/22 Allow advansys to accept 16-byte commands for wide boards
13/22 Remove some custom wrappers
15/22 Add DRV_NAME
16/22 Eliminate prototypes.  Boring and large.
19/22 Fix simultaneous calls to ->queuecommand

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
