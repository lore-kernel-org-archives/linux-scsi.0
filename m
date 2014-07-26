From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: break from queue depth adjusting loops when
	device found
Date: Sat, 26 Jul 2014 18:17:21 +0200
Message-ID: <20140726161721.GA6743@lst.de>
References: <20140703150557.21608.37072.stgit@beardog.cce.hp.com> <20140703171106.GA16788@lst.de> <53B6878C.502@suse.de> <94D0CD8314A33A4D9D801C0FE68B402958B86659@G9W0745.americas.hpqcorp.net> <20140726153612.GA6513@lst.de> <CADzpL0Rn+x6N=v123EBej_iZhTwmjMYZ4deeTeRG7_sxgXU9PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39524 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbaGZQR3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jul 2014 12:17:29 -0400
Content-Disposition: inline
In-Reply-To: <CADzpL0Rn+x6N=v123EBej_iZhTwmjMYZ4deeTeRG7_sxgXU9PQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Cameron <stephenmcameron@gmail.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, "james.bottomley@parallels.com" <james.bottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>

On Sat, Jul 26, 2014 at 11:14:35AM -0500, Stephen Cameron wrote:
> Hmm, I forgot that that patch was in there, I wasn't trying to keep pushing
> it along.  From the previous discussion, I got the impression I was simply
> wrong, and that this patch wasn't needed, so I had meant to drop it, I just
> forgot to actually drop it.

It's more complicated - as Robert indicated you're tenically right, although
in practice it's not what the existing users expect.  If you have some
cycles for it I'd love to at lest get the per-LUN and per-target
ramp up/down in ASAP.  We can then start looking into doing it even
better based on the target response later on.
