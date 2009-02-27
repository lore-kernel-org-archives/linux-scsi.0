From: Tony Battersby <tonyb@cybernetics.com>
Subject: sym53c8xx patches for scsi-misc
Date: Fri, 27 Feb 2009 10:22:06 -0500
Message-ID: <49A8051E.4050600@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:4035 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbZB0PWJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Feb 2009 10:22:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

James,

I posted a number of sym53c8xx patches back in early January that seem
to have been forgotten.  Would you please add these to scsi-misc?  Let
me know if you would prefer if I resend them instead of just posting
links to the archives.

http://marc.info/?l=linux-scsi&r=9&b=200901&w=4
[PATCH 0/7] sym53c8xx fixes
[PATCH 1/7] sym53c8xx: fix shost use-after-free and memory leak
[PATCH 2/7] sym53c8xx: fix NULL deref on error path
[PATCH 3/7] sym53c8xx: fix bogus free_irq() on error path
[PATCH 4/7] sym53c8xx: unmap pci memory after probe errors
[PATCH 5/7] sym53c8xx: handle pci_iomap() failures
[PATCH 6/7] sym53c8xx: use a queue depth of 1 for untagged devices
[PATCH 7/7] sym53c8xx: don't flood syslog with negotiation messages

The following patch was posted a year ago but forgotten.  I have been
using it for a long time, and it still applies cleanly.
sym53c8xx ISTAT1 feature never set
http://marc.info/?t=120076464500006&r=1&w=4
http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg13352.html

Tested with my approval (be sure to use the updated version):
[PATCH] sym53c8xx_2: slave_alloc/destroy safety (2.6.27.5)
http://marc.info/?l=linux-scsi&m=123063187829449&w=4

Tested with my approval:
[PATCH] sym53c8xx_2: lun to_clear flag not re-initialized (2.6.27.5)
http://marc.info/?t=122710178300003&r=1&w=4

Thanks,
Tony Battersby

