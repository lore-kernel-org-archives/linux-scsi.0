From: Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] iscsi-target: Merge for .40-rc1
Date: Mon, 30 May 2011 15:09:49 +0200
Message-ID: <20110530130949.GB13494@lst.de>
References: <1306551592.23461.506.camel@haakon2.linux-iscsi.org> <BANLkTimt5qisV7EH7NMv1tG8gR_9d-kA3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTimt5qisV7EH7NMv1tG8gR_9d-kA3g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Andy Grover <agrover@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, May 29, 2011 at 11:49:08AM -0700, Linus Torvalds wrote:
> I don't feel confident or motivated enough about iscsi-target, so
> after some (little) thought I ended up not pulling this. I really need
> a lot of acks from people who actually work on and care about SCSI,
> and right now I feel like with me being away for the next week, I
> can't handle it.
> 
> I just don't want to be in the situation where I pull something that
> is apparently contentious in the SCSI space in general, but that's
> _particularly_ true this release. So I'm afraid that this essentially
> got pushed out to the next release.

The main contention right now is wether to put the authentification
into kernel space or not.  Doing the slow path in userspace worked
out okay but not great on the initiator, but it has the potential
to become a nightmare worse than oprofile if the split ends up not
beeing perfect.

Given that we pretty well tested and working code that's used in lots
of production setups my vote is for taking it as-is unless someone can
actually show a prototype for a nicely working user/kernel split.
