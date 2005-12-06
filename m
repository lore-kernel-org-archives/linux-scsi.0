From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/2]  qla2xxx: important fixes for 2.6.15.
Date: Tue, 6 Dec 2005 10:55:21 -0800
Message-ID: <20051206185521.GD997@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:48444 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S965013AbVLFSzY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2005 13:55:24 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@steeleye.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

James,

Please queue these final bug-fixes for inclusion into 2.6.15:

- Correct mis-handling of AENs.
- Correct short-WRITE status handling.

Thanks,
Andrew Vasquez
