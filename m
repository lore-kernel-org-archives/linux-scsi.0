From: Christoph Hellwig <hch@infradead.org>
Subject: RFC: should we deprecate unmaintained isa-only drivers?
Date: Tue, 30 Dec 2014 08:06:16 -0800
Message-ID: <20141230160616.GA29149@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57582 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaL3QGR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Dec 2014 11:06:17 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Miroslav Zagorac <zaga@fly.cc.fer.hr>, Dario Ballabio <ballabio_dario@emc.com>

We've got a few very old, isa-only SCSI HBA drivers in the tree.  Of
those only one (aha152x) sas significant maintaince since the dawn
of git, all others only saw global / automatic updates.  4 of those
are fairly trivial wrappers aroudn the NCR538 core, so I don't mind
keeping them:

 - dtc
 - g_NCR5380
 - pas16
 - t128

but I'd love to know if anyone is actually using the other drivers:

 - wd7000
 - aha1542
 - in2000
 - NCR53c406
 - sym53c416
 - u14-34f
 - ultrastor

note that the last two even drive the same hardware.  There is
significant cruft in all these, so dropping them would help
further maintainance of the SCSI midlayer.
