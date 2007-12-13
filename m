From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [0/3 ver2] Last 3 patches for bidi support
Date: Thu, 13 Dec 2007 13:37:27 +0200
Message-ID: <47611977.5080702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:58875 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbXLMLl6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Dec 2007 06:41:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Russell King <rmk@arm.linux.org.uk>, Christo

James hi.

Bidi patches just broke again, by a patch that fixes
some to-be-dead code. (scsi: BUG_ON() impossible condition)

Could it not just be accepted into the tree now.
It sat in -mm tree with no reports of breakage or 
complains. What are we waiting for? the way I
see it there is nothing holding it back, it's
not even dangerous anymore.

You need Arm's accessors patch from scsi-pending
Russell King <rmk@arm.linux.org.uk>
Please send an Acked-by for this patch

and the patch that removes the old esp drivers
(http://www.spinics.net/lists/linux-scsi/msg20914.html)

Christoph Hellwig <hch@infradead.org>
David S. Miller <davem@davemloft.net>
Maciej W. Rozycki <macro@linux-mips.org>

Please send an Ack-by or Recommended-by to the removal
of these old esp drivers.

And the 3 patches (based on scsi-misc)
[1] tgt: Use scsi_init_io instead of scsi_alloc_sgtable
  Was Ack-by the maintainer of tgt. Please accept independent
  of the other 2.

[2] scsi: scsi_data_buffer
  The move to scsi_data_buffer. From here on any
  unconverted driver will not compile.

[3] scsi: bidi support
  Actual very simple really.

All parties involved, send your reservations if any NOW.
Else James please put it in.

Andrew could they be included back into -mm tree?

Boaz
