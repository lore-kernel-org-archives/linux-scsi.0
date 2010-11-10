From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] block: remove REQ_HARDBARRIER
Date: Wed, 10 Nov 2010 14:42:28 +0100
Message-ID: <20101110134227.GA4963@lst.de>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <201008241745.35242.philipp.reisner@linbit.com> <20101022083511.GA7853@lst.de> <201010231318.33517.philipp.reisner@linbit.com> <4CC311D5.9040904@fusionio.com> <20101023165924.GA1395@lst.de> <4CC3326E.5020009@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:47569 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab0KJNmc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2010 08:42:32 -0500
Content-Disposition: inline
In-Reply-To: <4CC3326E.5020009@fusionio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sat, Oct 23, 2010 at 09:07:26PM +0200, Jens Axboe wrote:
> Thanks Christoph, applied for 2.6.37 (but with a few days of brewing).

So, what's the plan?  I'd really hate to see 2.6.37 getting released
with those stale barrier bits left in.

