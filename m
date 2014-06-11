From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/14] block: Add prefix to block integrity profile flags
Date: Wed, 11 Jun 2014 09:46:14 -0700
Message-ID: <20140611164614.GB9511@infradead.org>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
 <1401334128-15499-8-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54263 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaFKQqS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 12:46:18 -0400
Content-Disposition: inline
In-Reply-To: <1401334128-15499-8-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org

On Wed, May 28, 2014 at 11:28:41PM -0400, Martin K. Petersen wrote:
> Add a BLK_ prefix to the integrity profile flags. Also rename the flags
> to be more consistent with the generate/verify terminology in the rest
> of the integrity code.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
