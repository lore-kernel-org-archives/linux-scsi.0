From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/14] block: Replace bi_integrity with bi_special
Date: Sat, 26 Jul 2014 08:24:52 -0700
Message-ID: <20140726152452.GB1854@infradead.org>
References: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
 <1406320469-29352-3-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40337 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaGZPYw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Jul 2014 11:24:52 -0400
Content-Disposition: inline
In-Reply-To: <1406320469-29352-3-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Not sure what this buys us until other uses show up, but it looks
fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

