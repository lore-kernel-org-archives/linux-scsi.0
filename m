From: Christoph Hellwig <hch@infradead.org>
Subject: Re: compile warning fix for advansys (trivial)
Date: Sun, 28 Dec 2003 20:05:48 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031228200548.A22668@infradead.org>
References: <Pine.LNX.4.44.0312212237460.2348-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:28681 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261957AbTL1UFt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Dec 2003 15:05:49 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0312212237460.2348-100000@poirot.grange>; from g.liakhovetski@gmx.de on Sun, Dec 21, 2003 at 10:40:49PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Sun, Dec 21, 2003 at 10:40:49PM +0100, Guennadi Liakhovetski wrote:
> Hi
> 
> This was earlier sent with a pretty masking subject to LKML, so, in case,
> it wasn't noticed by those, who collect stuff for 2.6.1+, here it is
> again.

It's not that easy.  You need to move the request_region as early as
the check_region is currently and make sure you properly release the
I/O region again on an initialization failure later on.

