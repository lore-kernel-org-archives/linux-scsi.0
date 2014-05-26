From: Bart Van Assche <bvanassche@acm.org>
Subject: Make SCSI error handler code easier to understand
Date: Mon, 26 May 2014 17:12:27 +0200
Message-ID: <538359DB.9080601@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:43654 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaEZPMa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 May 2014 11:12:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Joe Lawrence <jdl1291@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Every now and then someone asks how it is avoided that the SCSI error
handler and the SCSI completion handler are invoked concurrently for
the same SCSI command. Hence this patch series that should make the SCSI
error handler code a little easier to understand.

This patch series consists of the following three patches:

0001-Remove-two-cancel_delayed_work-calls-from-the-error-.patch
0002-block-Introduce-blk_rq_completed.patch
0003-Make-SCSI-error-handler-code-easier-to-understand.patch
