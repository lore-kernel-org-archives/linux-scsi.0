From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] gdth driver for 2.4.23-pre4
Date: Thu, 8 Jan 2004 17:13:14 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040108171314.A12595@infradead.org>
References: <3FFC5644.9060200@wanadoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:50447 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265631AbUAHRNS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2004 12:13:18 -0500
Content-Disposition: inline
In-Reply-To: <3FFC5644.9060200@wanadoo.es>; from xose@wanadoo.es on Wed, Jan 07, 2004 at 07:56:04PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose@wanadoo.es>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Tosatti <marcelo.tosatti@cyclades.com>

On Wed, Jan 07, 2004 at 07:56:04PM +0100, Xose Vazquez Perez wrote:
> hi,
> 
> latest driver update for 2.4 kernel:
> 
> - Disabled scan for EISA controllers
> - Using CACHE_READ_OEM_STRING_RECORD_IOCTL to set vendor
>   for SCSI inquiry.
> - Added support for XSCALE based RAID controllers
> - Reformated some code chunks

Patch looks ok, but I'd prefer a submission by the maintainer.

