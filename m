From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] kill blk_nohighio boot parameter
Date: Wed, 4 Jun 2003 09:45:08 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030604074508.GZ4853@suse.de>
References: <20030603212303.GA9562@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([213.95.15.193]:3845 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263025AbTFDHba (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2003 03:31:30 -0400
Content-Disposition: inline
In-Reply-To: <20030603212303.GA9562@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Tue, Jun 03 2003, Christoph Hellwig wrote:
> It was useful in 2.4 to debug the blockhighmem stuff but in 2.5
> it's b0rked because doesn't have any implication except propagation
> of the highmem_io flags from the scsi host template to the scsi
> host structure.  It also only worked on i386..

Agree

-- 
Jens Axboe

