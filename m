From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 0/5] add scsi_execute_async
Date: Fri, 11 Nov 2005 05:30:20 -0600
Message-ID: <1131708620.3066.18.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:27318 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750712AbVKKLab (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2005 06:30:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Here are the patches Christoph requested rediffed against the current
scsi-misc, plus one to add a kmemcache of scsi_io_context structs. I
made the patches against scsi-misc, but re-tested them against a older
kernel because the current git trees do not boot for me. This set of
patches does not included the blk_queue_max_sectors() patch or the
patches to convert the ULDs. I also dropped the dm-multipath hw_handler
conversion patches temporarily.

