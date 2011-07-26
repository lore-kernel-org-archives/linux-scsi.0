From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] iscsi-target merge for v3.1-rc1
Date: Tue, 26 Jul 2011 00:51:10 -0700
Message-ID: <1311666670.17766.241.camel@haakon2.linux-iscsi.org>
References: <1311462975.31450.356.camel@haakon2.linux-iscsi.org>
	 <20110725163739.5c19b04d.akpm@linux-foundation.org>
	 <20110725165057.9701f16b.akpm@linux-foundation.org>
	 <1311663071.17766.230.camel@haakon2.linux-iscsi.org>
	 <CA+55aFyNBaf2+=XJDLKNF1S5zMtpx38+Zd8uNd9k4ap4YpZmvw@mail.gmail.com>
	 <20110726004335.c6f26c5c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35723 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab1GZIAd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2011 04:00:33 -0400
In-Reply-To: <20110726004335.c6f26c5c.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Boaz Harrosh <openosd@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>

On Tue, 2011-07-26 at 00:43 -0700, Andrew Morton wrote:
> On Tue, 26 Jul 2011 00:09:40 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Just a simple
> > 
> > #define DIV_ROUND_UP_ULL(ll,d) \
> >   ({ unsigned long long _tmp = (ll)+(d)-1; do_div(_tmp, d); _tmp; })
> > 
> > looks like it would work and be simpler. Avoid the conditional, do the
> > same "add 'd-1' thing as the regular ROUND_UP().
> > 
> 
> We might end up needing a DIV_ROUND_UP_SECTOR_T because that guy's
> type/size is Kconfigurable.
> 
> otoh DIV_ROUND_UP_ULL won't have many callsites - the occasional
> conversion from UL to ULL then back to UL wouldn't kill us.  Unless
> there be subtle problems with such a conversion.
> 

Makes sense to me, and sending out updated series..  Anything else to
consider here folks before pushing into target-pending.git/for-next..?

Thanks!

--nab


