From: Christoph Hellwig <hch@infradead.org>
Subject: mpt2sas and mpt3sas merge (again)
Date: Mon, 14 Jul 2014 01:35:47 -0700
Message-ID: <20140714083547.GA6315@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55951 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaGNIfr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jul 2014 04:35:47 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com
Cc: linux-scsi@vger.kernel.org

Back when the mpt3sas driver was first posted I suggested that it should
be merged into mpt2sas, but my proposal didn't get much traction.

Illumos has now produced a shared driver and shown that the difference
are basically limited to a different S/G list format [1], and a quick
experiment on the Linux drivers confirms this mostly - the additional
differences are various smaller workarounds for specific hardware
revisions.

I think we'd all be served much better with a merged driver.

[1] http://thread.gmane.org/gmane.os.illumos.devel/17341
