From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 21/22] libfc: reset timeout on queue full
Date: Thu, 4 Aug 2016 16:08:52 +0200
Message-ID: <20160804140852.vc6ombzfzer7t3uw@c203.arch.suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
 <1470230002-37737-22-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758638AbcHDOpK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2016 10:45:10 -0400
Content-Disposition: inline
In-Reply-To: <1470230002-37737-22-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.com>

On Wed, Aug 03, 2016 at 03:13:21PM +0200, Hannes Reinecke wrote:
> When we're receiving a timeout we should be checking for queue
> full status; if there are still some packets pending we should
> be resetting the counter to ensure we're not missing out any
> packets which are still queued.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>

Maybe we can get the debug statements into one line, but anyways
Acked-by: Johannes Thumshirn <jth@kernel.org>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
