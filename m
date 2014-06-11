From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/14] block: Remove bip_buf
Date: Wed, 11 Jun 2014 09:35:48 -0700
Message-ID: <20140611163548.GD28815@infradead.org>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
 <1401334128-15499-5-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54077 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075AbaFKQfv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 12:35:51 -0400
Content-Disposition: inline
In-Reply-To: <1401334128-15499-5-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org

On Wed, May 28, 2014 at 11:28:38PM -0400, Martin K. Petersen wrote:
> bip_buf is not really needed so we can remove it.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
