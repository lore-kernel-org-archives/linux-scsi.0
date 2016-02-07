From: Christoph Hellwig <hch@lst.de>
Subject: Re: complete boot failure in 4.5-rc1 caused by nvme: make SG_IO
	support optional
Date: Sun, 7 Feb 2016 10:22:41 +0100
Message-ID: <20160207092241.GA15331@lst.de>
References: <1454783624.2809.6.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57344 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbcBGJWp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Feb 2016 04:22:45 -0500
Content-Disposition: inline
In-Reply-To: <1454783624.2809.6.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>

Keith said it should be on by default, and I promised him to change
it once we run into problems, which I guess this counts as.

But just curious:  what distro are you using?  Upstream systemd
explicitly rejected using scsi_id for NVMe here:

	https://github.com/systemd/systemd/issues/1453

and all my test systems don't do this either.
