From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] scsi: Remove CONFIG_SCSI_MULTI_LUN
Date: Thu, 22 May 2014 02:07:12 -0700
Message-ID: <20140522090712.GB14854@infradead.org>
References: <1400583791-123120-1-git-send-email-hare@suse.de>
 <1400583791-123120-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59178 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaEVJHM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2014 05:07:12 -0400
Content-Disposition: inline
In-Reply-To: <1400583791-123120-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>

On Tue, May 20, 2014 at 01:03:07PM +0200, Hannes Reinecke wrote:
> Obsolete; either use 'max_lun' if the host supports only a
> limited number of LUNs or BLIST_NOLUN if the target has
> problems addressing more than one LUN.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

