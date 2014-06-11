From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/14] block: Get rid of bdev_integrity_enabled()
Date: Wed, 11 Jun 2014 09:31:48 -0700
Message-ID: <20140611163148.GA28815@infradead.org>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
 <1401334128-15499-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52717 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbaFKQbx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 12:31:53 -0400
Content-Disposition: inline
In-Reply-To: <1401334128-15499-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org

On Wed, May 28, 2014 at 11:28:35PM -0400, Martin K. Petersen wrote:
> bdev_integrity_enabled() is only used by bio_integrity_enabled().
> Combine these two functions.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
