From: "Shirron, Stephen" <Stephen.Shirron@lsil.com>
Subject: RE: IP over FC and qlogic workarounds in fusion
Date: Tue, 7 Sep 2004 12:12:10 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <BC3CE0375D29D51199A400508B66CA6C099478E1@exc-snake.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:33730 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S268349AbUIGSNQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2004 14:13:16 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Emoore@lsil.com>
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

One problem I see with trying to remove this workaround from
our driver is that it would have to be coupled with a kernel
release, and then the newer driver would be bound to that release.
It would make it harder for customers to use a new driver kit with
an old kernel.

How is something like this typically addressed?

We are not opposed to making such a change.

stephen

-----Original Message-----
From: Christoph Hellwig [mailto:hch@lst.de] 
Sent: Monday, September 06, 2004 6:14 AM
To: Moore, Eric Dean
Cc: Christoph Hellwig; andrew.vasquez@qlogic.com;
linux-scsi@vger.kernel.org; Shirron, Stephen
Subject: Re: IP over FC and qlogic workarounds in fusion

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
