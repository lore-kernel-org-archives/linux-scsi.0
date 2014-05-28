From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] drivers/scsi/lpfc/lpfc_init.c: remove unnecessary
 casting
Date: Wed, 28 May 2014 03:42:17 -0700
Message-ID: <20140528104217.GF13542@infradead.org>
References: <1401212958-7710-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56707 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaE1KmS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 06:42:18 -0400
Content-Disposition: inline
In-Reply-To: <1401212958-7710-1-git-send-email-fabf@skynet.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

On Tue, May 27, 2014 at 07:49:18PM +0200, Fabian Frederick wrote:
> Fix coccicheck warning:
> "WARNING: casting value returned by k[cmz]alloc to (struct lpfc_sli_ring *) is useless."
> 
> Cc: James Smart <james.smart@emulex.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
