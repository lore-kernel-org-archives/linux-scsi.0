From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] revamp legacy host registration
Date: Tue, 3 Jun 2003 22:01:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030603220158.A28378@infradead.org>
References: <20030603205924.GA9262@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.mvhi.com ([195.224.96.167]:22290 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261168AbTFCUsd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jun 2003 16:48:33 -0400
Content-Disposition: inline
In-Reply-To: <20030603205924.GA9262@lst.de>; from hch@lst.de on Tue, Jun 03, 2003 at 10:59:24PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Tue, Jun 03, 2003 at 10:59:24PM +0200, Christoph Hellwig wrote:
> The legacy host registration/unregistration is the last user
> of the scsi_host_list but it really wants a per-template list
> instead, so switch to one that is maintained in
> scsi_register/scsi_unregister.  Also the legacy init/exit code
> is small enough now to be self-contained in scsi_module.c now.

And just btw, this breaks two usb scanner drivers still using
scsi_register_host in the scsi tree but they're already fixed
in mainline to use scsi_add_host directly.

