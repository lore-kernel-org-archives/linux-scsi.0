From: Christoph Hellwig <hch@infradead.org>
Subject: status of NCR5380-based ISA drivers
Date: Sun, 11 Sep 2016 10:12:49 -0700
Message-ID: <20160911171249.GA7554@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45742 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756131AbcIKRMw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2016 13:12:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org

Hi all,

you seem to the currently active NCR580 cabal.  Which frontends to NCR5380
do you test at the moment, or could you test?

NCR5380-based ISA drivers make up a significant part of those drivers still
using scsi_module.c after it's 15 year deprecation period, and I'd like to
either move them to this century or to the dust bin.

The drivers in question are: dtc, g_NCR5380, pas16 and t128.

Thanks,
	Christoph
