From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] scsi: use 64-bit value for 'max_luns'
Date: Thu, 22 May 2014 02:10:56 -0700
Message-ID: <20140522091056.GF14854@infradead.org>
References: <1400583791-123120-1-git-send-email-hare@suse.de>
 <1400583791-123120-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33899 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaEVJK5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2014 05:10:57 -0400
Content-Disposition: inline
In-Reply-To: <1400583791-123120-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>

On Tue, May 20, 2014 at 01:03:11PM +0200, Hannes Reinecke wrote:
> Now that we're using 64-bit LUNs internally we need to increase
> the size of max_luns to 64 bits, too.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
