From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 6/6] cciss: fix bug if scsi tape support is disabled
Date: Thu, 7 Aug 2008 20:28:50 +0200
Message-ID: <20080807182849.GC20055@kernel.dk>
References: <20080730211842.GF1758@roadking.ldev.net> <20080804095633.GA20055@kernel.dk> <20080805153012.0076396e.akpm@linux-foundation.org> <20080806130825.1567d882.sfr@canb.auug.org.au> <20080806103308.GM20055@kernel.dk> <20080807094305.8d315d06.sfr@canb.auug.org.au> <0F5B06BAB751E047AB5C87D1F77A778826B3F16682@GVW0547EXC.americas.hpqcorp.net> <20080807172028.GX20055@kernel.dk> <0F5B06BAB751E047AB5C87D1F77A778826B3F6BEF4@GVW0547EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:21916 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbYHGS2y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2008 14:28:54 -0400
Content-Disposition: inline
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A778826B3F6BEF4@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "scameron@beardog.cca.cpqcorp.net" <scameron@beardog.cca.cpqcorp.net>

On Thu, Aug 07 2008, Miller, Mike (OS Dev) wrote:
> Jens wrote:
> 
> > > > > uptodate more frequently :-)
> > > >
> > >
> > > I still can't find my latest patches in any tree. Jens?
> >
> > It's in for-next, for-akpm, and for-linus. It'll be going
> > upstream for this release, 2.6.27.
> 
> Thanks, I'm just a bit impatient I guess. When a patch makes into
> for-* how long would it take to get to Linus' git tree?

Oh that depends entirely on what else it's queued with, but for
something going into the current branch, usually 2 weeks at the most.

-- 
Jens Axboe

