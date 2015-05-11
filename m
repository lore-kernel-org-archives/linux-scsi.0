From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 3/5] Replace MAX_COMMAND_SIZE with BLK_MAX_CDB
Date: Mon, 11 May 2015 09:56:44 +0200
Message-ID: <20150511075644.GA32395@lst.de>
References: <554C6E79.7020501@sandisk.com> <554C6EFF.5000400@sandisk.com> <20150511063250.GD30323@lst.de> <5550605B.904@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39226 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbbEKH4q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 03:56:46 -0400
Content-Disposition: inline
In-Reply-To: <5550605B.904@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jbottomley@odin.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Felipe Balbi <balbi@ti.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>

On Mon, May 11, 2015 at 09:55:07AM +0200, Bart Van Assche wrote:
> Actually this makes my job easier because it allows me to drop a whole
> bunch of changes. Is the patch below what you had in mind ?

Yes, this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
