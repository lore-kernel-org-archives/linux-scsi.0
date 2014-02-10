From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/15] A different approach for using blk-mq in the SCSI
 layer
Date: Mon, 10 Feb 2014 03:35:52 -0800
Message-ID: <20140210113552.GA27357@infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44287 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbaBJLgA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Feb 2014 06:36:00 -0500
Content-Disposition: inline
In-Reply-To: <20140205124118.332902571@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

On Wed, Feb 05, 2014 at 04:41:18AM -0800, Christoph Hellwig wrote:
> A git tree is also available at
> 
>   git://git.infradead.org/users/hch/scsi.git#scsi-mq-wip

I've pushed various fixes to the branch, most importantly the ata_piix
driver including CDROM support has now been tested with blk-mq, and
timeouts and basic EH now work properly.
