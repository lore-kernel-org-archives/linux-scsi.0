From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [Lsf] [TOPIC] scsi-queue tree past and future
Date: Fri, 06 Mar 2015 20:47:14 -0800
Message-ID: <1425703634.19505.113.camel@stgolabs.net>
References: <20150305133118.GA16575@lst.de>
	 <1425566888.2169.17.camel@HansenPartnership.com>
	 <1425702152.19505.106.camel@stgolabs.net>
	 <1425703385.2154.66.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbbCGErV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Mar 2015 23:47:21 -0500
In-Reply-To: <1425703385.2154.66.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: lsf@lists.linux-foundation.org, lsf-pc@lists.linux-foundation.org, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Fri, 2015-03-06 at 20:43 -0800, James Bottomley wrote:
> Well, to clarify what's happening: I'm not running the tests, I asked
> the 0 day kernel testing project to run them on all the patches in my
> tree.  The 0 day project has a bunch of standard tests for all trees and
> then some optional ones (like xfstests) which I asked Fengguang to turn
> on in our case.
> 
> Trinity is part of the 0 day project tests, so I could ask for it to be
> turned on too, 

Oh, I was not aware of that. I tend to consider LTP something completely
unrelated.

> but I'm not sure it would be so useful for SCSI: trinity
> is a sys call fuzzing tool but the sys call exposure of SCSI is pretty
> tiny.  xfstests, which exercise the filesystem data above us provide a
> much wider range of testing.

Yeah I'm really talking at a generic level, just like LTP.

Thanks,
Davidlohr

