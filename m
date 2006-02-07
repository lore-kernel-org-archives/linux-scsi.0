From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/4]  qla2xxx: fixes for 2.6.16.
Date: Tue, 7 Feb 2006 08:39:37 -0800
Message-ID: <20060207163937.GC1405@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:40822 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1750867AbWBGQjj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2006 11:39:39 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@steeleye.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

James,

Please queue these bug-fixes for inclusion into 2.6.16:

- Remove bogus debug-code.
- Correct lun assignment during IOCB submission.
- Pass input-buffer length to Get-ID-List mailbox command.
- Close window on race between rport removal and fcport transition.

Thanks,
Andrew Vasquez
