From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: IP over FC and qlogic workarounds in fusion
Date: Mon, 06 Sep 2004 21:16:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094530577.29434.7.camel@praka>
References: <0E3FA95632D6D047BA649F95DAB60E5704F631BE@exa-atlanta>
	 <20040906101349.GA17669@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:7265 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S267545AbUIGESE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 00:18:04 -0400
In-Reply-To: <20040906101349.GA17669@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Moore, Eric Dean" <Emoore@lsil.com>, linux-scsi@vger.kernel.org, "Shirron, Stephen" <Stephen.Shirron@lsil.com>

On Mon, 2004-09-06 at 03:13, Christoph Hellwig wrote:
> On Mon, Aug 30, 2004 at 06:29:47PM -0400, Moore, Eric Dean wrote:
> > Here is feedback from Stephen Shirron, co-worker here
> > at LSI Logic:
> > 
> > To my knowledge QLogic has never even acknowledged that
> > they had a bug.  In my opinion it is not
> > safe to remove this code.  We do have versions of the FC
> > firmware that work around this QLogic bug, but it's hard
> > to know if the entire field is populated.  It would not
> > be good to introduce a regression that decreases our
> > interoperability.
> 
> Andrew, could you please try to to find the right people at Qlogic
> to ACK or even better fix this?
> 

I'm not sure who Stephen originally worked with at QLogic, but yes, this
is a known problem (finally managed to track down several firmware
engineers) and unfortunately 'will not be addressed' in the future.

You'll also note that FC-IP support has effectively been extricated from
the 8.x series driver.

Regards,
Andrew Vasquez
