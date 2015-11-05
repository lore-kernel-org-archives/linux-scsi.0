From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] Restart list search after unlock in
	scsi_remove_target
Date: Thu, 5 Nov 2015 09:51:23 +0100
Message-ID: <20151105085123.GB20249@lst.de>
References: <5633E9F2.5080209@sandisk.com> <5633EA98.8050604@sandisk.com> <563A883C.9060501@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37219 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030329AbbKEIvZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Nov 2015 03:51:25 -0500
Content-Disposition: inline
In-Reply-To: <563A883C.9060501@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Nov 04, 2015 at 02:35:40PM -0800, Bart Van Assche wrote:
> (replying to my own e-mail)
>
> Hello Christoph,
>
> Is it OK for you if I mention you as author of this e-mail ?

I don't care whom this fix is attributed to, but let's get it in:

Reviewed-by: Christoph Hellwig <hch@lst.de>

or

Signed-off-by: Christoph Hellwig <hch@lst.de>

at your preference :)
