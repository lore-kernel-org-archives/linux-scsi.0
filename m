From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH 0/3] iscsi iser limits
Date: Tue, 12 Feb 2008 15:52:52 -0500
Message-ID: <20080212205252.GB13643@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:39868 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842AbYBLUw5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2008 15:52:57 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Erez Zilber <erezz@voltaire.com>, Roland Dreier <rolandd@cisco.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

These three patches remove various block device limits to
the iSER iSCSI transport.  I guess in theory they should go
in via the IB tree, although ACKs from the iSCSI side would
be welcome.

The first two look quite similar to some TCP iSCSI patches
that Mike applied a while back:

    d1d81c01f4bdd50577d9f89aa4a8e6344f63aa70
	[SCSI] iscsi_tcp: remove DMA alignment restriction

    8231f0eddbe425cc3b54f2d723bb03531925272e
	[SCSI] iscsi_tcp: increase max_sectors

The third fixes a problem with mapping an unaligned 512 kB
buffer and takes the opportunity to increase the FMR mapping
limit to 1 MB, as is done in SRP.

		-- Pete

