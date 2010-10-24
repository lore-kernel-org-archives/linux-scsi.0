From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] block: remove REQ_HARDBARRIER
Date: Sun, 24 Oct 2010 13:58:37 +0200
Message-ID: <20101024115837.GA25644@lst.de>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <201008241745.35242.philipp.reisner@linbit.com> <20101022083511.GA7853@lst.de> <201010231318.33517.philipp.reisner@linbit.com> <4CC311D5.9040904@fusionio.com> <20101023165924.GA1395@lst.de> <4CC3326E.5020009@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:35061 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443Ab0JXL6k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2010 07:58:40 -0400
Content-Disposition: inline
In-Reply-To: <4CC3326E.5020009@fusionio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sat, Oct 23, 2010 at 09:07:26PM +0200, Jens Axboe wrote:
> Thanks Christoph, applied for 2.6.37 (but with a few days of brewing).

Btw, in case it wasn't clear - this needs to be applied only after the
drbd patches that remove the drbd use of REQ_HARDBARRIER.
