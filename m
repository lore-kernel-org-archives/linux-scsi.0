From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] allow a transport to pre-initialize starget_data
Date: Mon, 15 Aug 2005 17:25:00 +0200
Message-ID: <20050815152500.GA21103@lst.de>
References: <20050815134210.GA19426@lst.de> <4300B232.9000308@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:6355 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964804AbVHOPZF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 11:25:05 -0400
Content-Disposition: inline
In-Reply-To: <4300B232.9000308@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Mon, Aug 15, 2005 at 11:18:10AM -0400, Luben Tuikov wrote:
> On 08/15/05 09:42, Christoph Hellwig wrote:
> > Add a new void *transport_data argument to scsi_scan_target so that a
> > transport-class can fill in known information before actually scanning
> > the target.  This is needed by the upcoming SAS transport class patch.
> 
> Hmm, yes, this has been due for 5 years now.
> 
> While you're at it, rip out the extremely broken "channel" and "id",
> and leave only the opaque token.

Well, it's not a token but pre-initialized data.  The problem with
ripping out channel and id is that userland would break all over,
else we'd have done it already.
