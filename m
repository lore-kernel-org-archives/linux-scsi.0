From: Olivier Galibert <galibert@pobox.com>
Subject: Re: [GIT PULL] iscsi-target merge for v3.1-rc1
Date: Tue, 26 Jul 2011 12:08:04 +0200
Message-ID: <20110726100804.GA6069@dspnet.fr>
References: <1311462975.31450.356.camel@haakon2.linux-iscsi.org>
 <20110725163739.5c19b04d.akpm@linux-foundation.org>
 <20110725165057.9701f16b.akpm@linux-foundation.org>
 <1311663071.17766.230.camel@haakon2.linux-iscsi.org>
 <CA+55aFyNBaf2+=XJDLKNF1S5zMtpx38+Zd8uNd9k4ap4YpZmvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyNBaf2+=XJDLKNF1S5zMtpx38+Zd8uNd9k4ap4YpZmvw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andrew Morton <akpm@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Boaz Harrosh <openosd@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 26, 2011 at 12:09:40AM -0700, Linus Torvalds wrote:
> And it just looks unnecessarily complicated. Just a simple
> 
> #define DIV_ROUND_UP_ULL(ll,d) \
>   ({ unsigned long long _tmp = (ll)+(d)-1; do_div(_tmp, d); _tmp; })
> 
> looks like it would work and be simpler. Avoid the conditional, do the
> same "add 'd-1' thing as the regular ROUND_UP().
> 
> Untested. And not much thinking involved.

Overflow risk?  Of course DIV_ROUND_UP has the same issue, and looks
slight easier to trigger, maybe.

  OG.
