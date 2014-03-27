From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] scsi: use 64-bit LUNs
Date: Thu, 27 Mar 2014 07:52:07 -0700
Message-ID: <20140327145207.GC16958@infradead.org>
References: <1386673515-87133-1-git-send-email-hare@suse.de>
 <1386673515-87133-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36050 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbaC0OwL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2014 10:52:11 -0400
Content-Disposition: inline
In-Reply-To: <1386673515-87133-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Steffen Maier <maier@linux.vnet.ibm.com>

On Tue, Dec 10, 2013 at 12:05:14PM +0100, Hannes Reinecke wrote:
> The SCSI standard defines 64-bit values for LUNs, and large arrays
> employing large or hierarchical LUN numbers become more and more
> common.
> 
> So update the linux SCSI stack to use 64-bit LUN numbers.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
