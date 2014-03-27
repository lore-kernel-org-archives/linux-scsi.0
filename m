From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] scsi: use 64-bit value for 'max_luns'
Date: Thu, 27 Mar 2014 07:52:33 -0700
Message-ID: <20140327145233.GD16958@infradead.org>
References: <1386673515-87133-1-git-send-email-hare@suse.de>
 <1386673515-87133-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36056 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbaC0Owf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2014 10:52:35 -0400
Content-Disposition: inline
In-Reply-To: <1386673515-87133-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Tue, Dec 10, 2013 at 12:05:15PM +0100, Hannes Reinecke wrote:
> Now that we're using 64-bit LUNs internally we need to increase
> the size of max_luns to 64 bits, too.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
