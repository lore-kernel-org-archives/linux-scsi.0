From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi/Kconfig tidyup
Date: Wed, 11 Feb 2004 19:51:09 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040211195109.A23991@infradead.org>
References: <20040211194600.GS13351@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:49160 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265691AbUBKTvL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2004 14:51:11 -0500
Content-Disposition: inline
In-Reply-To: <20040211194600.GS13351@parcelfarce.linux.theplanet.co.uk>; from willy@debian.org on Wed, Feb 11, 2004 at 07:46:00PM +0000
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org

On Wed, Feb 11, 2004 at 07:46:00PM +0000, Matthew Wilcox wrote:
> 
> This patch corrects a couple of typos in drivers/scsi/Kconfig and
> makes the SCSI drivers menu depend on SCSI rather than on SCSI!=n.
> That has the effect of making every driver depend on SCSI, so we don't
> need the explicit dependency for every driver.

I'd rather kill that menu then actively using it for depencies..

