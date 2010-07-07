From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] scsi: address leak in scsi_setup_discard_cmnd error path (was: Re: scsi: unify the error handling of the prep functions)
Date: Wed, 7 Jul 2010 21:44:31 +0200
Message-ID: <20100707194431.GA20206@lst.de>
References: <20100705125651R.fujita.tomonori@lab.ntt.co.jp> <20100705134529.GA18645@redhat.com> <20100706135958.GA10772@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:47431 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756854Ab0GGTpG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jul 2010 15:45:06 -0400
Content-Disposition: inline
In-Reply-To: <20100706135958.GA10772@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, hch@lst.de, dm-devel@redhat.com

> Here is a minimalist patch that 1) removes the discard request's page
> leak 2) preserves the prep cleanup rules covered above.  Fixing the leak
> is a priority, introducing additional error path code sharing/cleanup is
> secondary and can come later.

I much prefer this approach.

> Signed-off-by: Mike Snitzer <snitzer@redhat.com>


Reviewed-by: Christoph Hellwig <hch@lst.de>


