From: Jamie Lenehan <lenehan@twibble.org>
Subject: Re: [PATCH] dc395x fix memory mapping (was Re: dc395x: can't write to tape)
Date: Wed, 23 Feb 2005 21:16:18 +1100
Message-ID: <20050223101615.GA5930@twibble.org>
References: <200501060518.25782.andrex@alumni.utexas.net> <Pine.LNX.4.60.0501062138580.7568@poirot.grange> <20050109053342.GA5799@twibble.org> <Pine.LNX.4.60.0501091238010.3910@poirot.grange> <20050109125116.GA6293@twibble.org> <Pine.LNX.4.60.0501222356400.5769@poirot.grange> <Pine.LNX.4.60.0502062309570.5347@poirot.grange> <Pine.LNX.4.60.0502212258460.5642@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from tuon.twibble.org ([202.173.155.197]:35813 "EHLO
	tuon.twibble.org") by vger.kernel.org with ESMTP id S261445AbVBWKQ3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2005 05:16:29 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0502212258460.5642@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Mon, Feb 21, 2005 at 11:01:27PM +0100, Guennadi Liakhovetski wrote:
> On Sun, 6 Feb 2005, Guennadi Liakhovetski wrote:
> 
> > Two weeks since I posted this patch - ping...
> 
> ...and another two weeks since you, Jamie, replied to me privately. Just 
> wanted to say, it would be good to get this bug fixed for the post-2.6.11 
> SCSI patch.

Yep.
I've been rather busy and have not had any time to look at this. The patch
looks good and I've had no issues testing it now with highmem enabled on my
4G DAT drive.

I'll submit the patch in a minute.

Thanks.
Jamie.

-- 
 Jamie Lenehan <lenehan@twibble.org>
