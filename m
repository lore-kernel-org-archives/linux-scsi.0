From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] tmscsim: INQUIRY always only untagged
Date: Sat, 4 Sep 2004 23:38:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040904233835.A18659@infradead.org>
References: <Pine.LNX.4.60.0409040033310.5266@poirot.grange> <20040904140102.A15247@infradead.org> <Pine.LNX.4.60.0409050022570.3092@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:30726 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264213AbUIDWij (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Sep 2004 18:38:39 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0409050022570.3092@poirot.grange>; from g.liakhovetski@gmx.de on Sun, Sep 05, 2004 at 12:26:14AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Sun, Sep 05, 2004 at 12:26:14AM +0200, Guennadi Liakhovetski wrote:
> On Sat, 4 Sep 2004, Christoph Hellwig wrote:
> 
> > On Sat, Sep 04, 2004 at 12:41:00AM +0200, Guennadi Liakhovetski wrote:
> >> Hello
> >>
> >> The attached patch makes sure, all INQUIRY commands are only sent
> >> untagged. This way drives, affected by bug 2139, also survive further
> >> INQUIRYs, sent after the initial scan, e.g., by scsiinfo.
> >
> > Looks basically good to me, but if you want to store SCSI_NO_TAG in
> > ->TagNumber I'd suggest that you make it an unsigned type.
> 
> It is unsigned (u8) now. Or did you mean signed, since SCSI_NO_TAG is 
> defined as (-1). I thought about making TagNumber an int, but I didn't 
> bother, because it is anyway due removal...

Umm, yes signed of course.

