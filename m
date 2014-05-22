From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] scsi_scan: Restrict sequential scan to 256 LUNs
Date: Thu, 22 May 2014 02:08:47 -0700
Message-ID: <20140522090847.GC14854@infradead.org>
References: <1400583791-123120-1-git-send-email-hare@suse.de>
 <1400583791-123120-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60091 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaEVJIr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2014 05:08:47 -0400
Content-Disposition: inline
In-Reply-To: <1400583791-123120-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>

On Tue, May 20, 2014 at 01:03:08PM +0200, Hannes Reinecke wrote:
> Sequential scan for more than 256 LUNs is very fragile as
> LUNs might not be numbered sequentially after that point.
> 
> SAM revisions later than SCSI-3 impose a structure on
> LUNs larger than 256, making LUN numbers between 256
> and 16384 illegal.
> SCSI-3, however allows for plain 64-bit numbers with
> no internal structure.
> 
> So restrict sequential LUN scan to 256 LUNs and add a
> new blacklist flag 'BLIST_SCSI3LUN' to scan up to
> max_lun devices.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Do you know any common devices reporting SCSI-2?  I've only really seen 
SCSI-2 and never SBC levels in practical use.
