From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 0 of 9] I/O topology patch kit
Date: Fri, 24 Apr 2009 01:32:21 -0400
Message-ID: <patchbomb.1240551141__37598.8422929824$1240551473$gmane$org@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:42198 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbZDXFgK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2009 01:36:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, matthew@wil.cx, linux-ide


Second take of the I/O topology patches.

Changes:

 - PATCH 2 of 8: New naming as suggested by Jens. Document sysfs ABI.
 - PATCH [346] of 8: Updated to use the new blk_queue_io_foo() calls.
 - PATCH 8: Wilcox & Petersen libata READ CAPACITY(16) convergence.
 - PATCH 9: libata rotation rate heuristics

Wrt. patch 9: Flame away :)

-- 
Martin K. Petersen	Oracle Linux Engineering


