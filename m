From: Tony Battersby <tonyb@cybernetics.com>
Subject: Recent sym53c8xx patches
Date: Tue, 27 Nov 2007 09:51:56 -0500
Message-ID: <474C2F0C.6030303@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host06.cybernetics.com ([206.246.200.22]:2699 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758833AbXK0Ov5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Nov 2007 09:51:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, jejb@kernel.org, hch@infradead.org

Hello,

I am sending this message to check up on the merge status of my recent
sym53c8xx patches to make sure they aren't forgotten.  Matthew Wilcox,
could you give an ack/nak for these merge requests?  Also, please let me
know if I need to do anything else (such as resending later) to make
sure these patches get merged.

[PATCH] [SCSI] sym53c8xx: fix free_irq() regression in 2.6.24
http://marc.info/?t=119438263300007&r=1&w=4
Regression fix.  Should be merged in 2.6.24.  OK'ed by Christoph Hellwig.

[PATCH] [SCSI] sym53c8xx: fix resid calculation
http://marc.info/?l=linux-scsi&m=119438360705773&w=4
Bug fix.  I would like it to be merged in 2.6.24.  No replies to initial
message.

[PATCH] [SCSI] sym53c8xx: don't flood syslog with negotiation messages
http://marc.info/?l=linux-scsi&m=119446914818689&w=4
More an annoyance fix than a bug fix.  Probably safe to merge for
2.6.24, but could wait for 2.6.25 if someone objects.  No replies to
initial message.

[PATCH] [SCSI] sym53c8xx: fix setflag user command to control disconnects
http://marc.info/?l=linux-scsi&m=119446790116497&w=4
Fix for long-broken not-widely-used feature.  Can be dropped if the
disconnect attribute will be added to the SPI transport class in the
near future.  Is anyone working on this BTW?

[PATCH] [SCSI] sym53c8xx: increase sg_tablesize for larger data transfers
http://marc.info/?l=linux-scsi&m=119513922112712&w=4
Enhancement.  On hold for the moment due to speculation that it may
break some 875 chips.

Thanks,
Tony Battersby

