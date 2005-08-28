From: Jeff Garzik <jgarzik@pobox.com>
Subject: libata: clustering on or off?
Date: Sun, 28 Aug 2005 05:42:18 -0400
Message-ID: <20050828094218.GA29145@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:8340 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1750800AbVH1JmT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Aug 2005 05:42:19 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: axboe@suse.de


The constant ATA_SHT_USE_CLUSTERING in include/linux/libata.h controls
the use of SCSI layer's use_clustering feature, for a great many libata
drivers.

The current setup has clustering disabled, which in theory causes the
block layer to do less work, at the expense of a greater number of
scatter/gather table entries used.

Any opinions WRT turning on clustering for libata?

	Jeff



