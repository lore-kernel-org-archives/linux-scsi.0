From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] virtio scsi: fix unused variable warning
Date: Fri, 3 Jul 2015 18:04:38 +0200
Message-ID: <20150703160438.GA2086@lst.de>
References: <20150630105904.4c3d46b1@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56491 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755771AbbGCQEk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jul 2015 12:04:40 -0400
Content-Disposition: inline
In-Reply-To: <20150630105904.4c3d46b1@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <JBottomley@Odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Michael S. Tsirkin" <mst@redhat.com>

On Tue, Jun 30, 2015 at 10:59:04AM +1000, Stephen Rothwell wrote:
> Fixes:
> 
> drivers/scsi/virtio_scsi.c: In function 'virtscsi_probe':
> drivers/scsi/virtio_scsi.c:952:11: warning: unused variable 'host_prot' [-Wunused-variable]
>   int err, host_prot;
>            ^
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Thanks, this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
