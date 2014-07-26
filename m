From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/14] block: Make protection interval calculation generic
Date: Sat, 26 Jul 2014 08:26:59 -0700
Message-ID: <20140726152659.GD1854@infradead.org>
References: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
 <1406320469-29352-7-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42126 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaGZP07 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Jul 2014 11:26:59 -0400
Content-Disposition: inline
In-Reply-To: <1406320469-29352-7-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 25, 2014 at 04:34:21PM -0400, Martin K. Petersen wrote:
> +	return sectors >> (ilog2(bi->interval) - 9);

I was going to say this should be 'SECTOR_SHIFT', but that constant
or variants of it are only defined locally in various subsystems..

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
