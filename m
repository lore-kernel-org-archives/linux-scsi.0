From: Dave Jones <davej@redhat.com>
Subject: spinning up memory sticks.
Date: Mon, 9 Aug 2004 13:28:16 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040809122816.GA21238@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from delerium.kernelslacker.org ([81.187.208.145]:64388 "EHLO
	delerium.codemonkey.org.uk") by vger.kernel.org with ESMTP
	id S266534AbUHIM3f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Aug 2004 08:29:35 -0400
Received: from delerium.codemonkey.org.uk (localhost.localdomain [127.0.0.1])
	by delerium.codemonkey.org.uk (8.13.1/8.13.1) with ESMTP id i79CSIgd021717
	for <linux-scsi@vger.kernel.org>; Mon, 9 Aug 2004 13:28:18 +0100
Received: (from davej@localhost)
	by delerium.codemonkey.org.uk (8.13.1/8.13.0/Submit) id i79CSGqU021716
	for linux-scsi@vger.kernel.org; Mon, 9 Aug 2004 13:28:16 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've only just noticed this happening, but its possible its
been this way for quite a while.  When I try to mount my
cameras memory stick using a usb multi-card reader,
it now prints this message..
sdd: Spinning up disk

waits a while, and then prints 

.............ready
SCSI device sdd: 253888 512-byte hdwr sectors (130 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 00 00 00
sdd: assuming drive cache: write through
sdd: sdd1
Attached scsi removable disk sdd at scsi0, channel 0, id 0, lun 3


Did something recently change which could affect this ?

caveat: I've only tested this with a Fedora kernel so far, but afair,
we don't patch anything which could affect this.

		Dave

