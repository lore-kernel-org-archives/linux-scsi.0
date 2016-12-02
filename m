From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_dh_alua: Fix RCU annotations
Date: Fri, 2 Dec 2016 04:22:49 -0800
Message-ID: <20161202122249.GB14247@infradead.org>
References: <75470dc5-b79a-088c-49a8-65cfe282376f@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39866 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753396AbcLBMWz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2016 07:22:55 -0500
Content-Disposition: inline
In-Reply-To: <75470dc5-b79a-088c-49a8-65cfe282376f@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, tang.junhui@zte.com.cn, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Dec 01, 2016 at 11:30:50AM -0800, Bart Van Assche wrote:
> This patch avoids that sparse complains about RCU pointer dereferences.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
