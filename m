From: Christoph Hellwig <hch@lst.de>
Subject: Re: IP over FC and qlogic workarounds in fusion
Date: Tue, 7 Sep 2004 20:14:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040907181415.GB12654@lst.de>
References: <BC3CE0375D29D51199A400508B66CA6C099478E1@exc-snake.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:1438 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268314AbUIGSOa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2004 14:14:30 -0400
Content-Disposition: inline
In-Reply-To: <BC3CE0375D29D51199A400508B66CA6C099478E1@exc-snake.co.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Shirron, Stephen" <Stephen.Shirron@lsil.com>
Cc: "Moore, Eric Dean" <Emoore@lsil.com>, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Tue, Sep 07, 2004 at 12:12:10PM -0600, Shirron, Stephen wrote:
> One problem I see with trying to remove this workaround from
> our driver is that it would have to be coupled with a kernel
> release, and then the newer driver would be bound to that release.
> It would make it harder for customers to use a new driver kit with
> an old kernel.
> 
> How is something like this typically addressed?

Backport the stack changes aswell when you want to run an older release.

There's a lot of recent additions additions that move code from drivers
to the stack and you need to make sure that the stack code is uptodate
to use all those features.
