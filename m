From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH 0/3] bsg bidirectional and variable length commands
Date: Wed, 15 Aug 2007 14:15:23 -0500
Message-ID: <20070815191523.GA14977@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:51177 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949AbXHOTXZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2007 15:23:25 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

There are three patches here to enable using BSG to send SCSI
commands across iscsi TCP that are bidirectional and/or use
variable length CDBs.  They sit on top of 2.6.23-rc2 plus Mike's
iscsi git plus the 12 core patches that Boaz has for bidirectional
support.

They apply to stock 2.6.23-rc2 but I don't think it is worth
anybody's time to take them yet.  Instead, I think it makes sense
for Boaz to hang onto these and submit them along as part of
the bigger bidirectional support picture.

		-- Pete

