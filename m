From: Christoph Hellwig <hch@lst.de>
Subject: Re: IP over FC and qlogic workarounds in fusion
Date: Mon, 6 Sep 2004 12:13:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040906101349.GA17669@lst.de>
References: <0E3FA95632D6D047BA649F95DAB60E5704F631BE@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:7150 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267543AbUIFKOG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2004 06:14:06 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5704F631BE@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, "Shirron, Stephen" <Stephen.Shirron@lsil.com>

On Mon, Aug 30, 2004 at 06:29:47PM -0400, Moore, Eric Dean wrote:
> Here is feedback from Stephen Shirron, co-worker here
> at LSI Logic:
> 
> To my knowledge QLogic has never even acknowledged that
> they had a bug.  In my opinion it is not
> safe to remove this code.  We do have versions of the FC
> firmware that work around this QLogic bug, but it's hard
> to know if the entire field is populated.  It would not
> be good to introduce a regression that decreases our
> interoperability.

Andrew, could you please try to to find the right people at Qlogic
to ACK or even better fix this?

Eric, are you and your LSI coworkers willing to integrate the workaround
with the net/802/fc.c code and make fusion use it?
