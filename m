From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] Declare local symbols static
Date: Tue, 29 Mar 2016 00:33:54 -0700
Message-ID: <20160329073354.GA8568@infradead.org>
References: <56F9740A.4060100@sandisk.com>
 <56F9743C.8040301@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40441 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbcC2Hd6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2016 03:33:58 -0400
Content-Disposition: inline
In-Reply-To: <56F9743C.8040301@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Mar 28, 2016 at 11:13:16AM -0700, Bart Van Assche wrote:
> Avoid that building with W=1 causes gcc to report warnings about
> symbols that have not been declared.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.de>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
