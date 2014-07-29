From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [RFD] brd.ko Never supported partitions should we remove the
 dead code ?
Date: Tue, 29 Jul 2014 12:56:03 -0400
Message-ID: <20140729165603.GN6754@linux.intel.com>
References: <53D7CDDD.1000302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44749 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbaG2Q4O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2014 12:56:14 -0400
Content-Disposition: inline
In-Reply-To: <53D7CDDD.1000302@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <openosd@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Ross Zwisler <ross.zwisler@linux.intel.com>

On Tue, Jul 29, 2014 at 07:37:49PM +0300, Boaz Harrosh wrote:
> But before we are running to fix this bug. Could we please do better and just remove the support for partitions
> all together.
> 	Since it *never* worked anyway, so probably no one needs it! Surly no one used it

I fixed this in patch 4/22 of the v8 series.  The correct place to
handle partitioning is in the block layer, not the individual drivers
(nor the filesystems).
