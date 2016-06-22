From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] target/iblock: use ilog2 to compute block size
Date: Wed, 22 Jun 2016 06:38:09 -0700
Message-ID: <20160622133809.GA29657@infradead.org>
References: <20160622125534.1267407-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55695 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbcFVNiN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2016 09:38:13 -0400
Content-Disposition: inline
In-Reply-To: <20160622125534.1267407-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

This doesn't compute the block size, it computes the number of block
in a block device.  I think it would be useful to add a generic helper
(e.g. in blkdev.h) as this calculation seems to be open coded in various
places.
