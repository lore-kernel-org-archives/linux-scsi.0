From: Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] target updates for v3.16-rc1
Date: Fri, 13 Jun 2014 18:41:18 +0200
Message-ID: <20140613164118.GA17282@lst.de>
References: <1402607116.18202.46.camel@haakon3.risingtidesystems.com> <20140613133901.GC7371@lst.de> <1402672861.2224.11.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1402672861.2224.11.camel@dabdike.int.hansenpartnership.com>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Paolo Bonzini <pbonzini@redhat.com>, Quinn Tran <quinn.tran@qlogic.com>, "Michael S. Tsirkin" <mst@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 13, 2014 at 08:21:01AM -0700, James Bottomley wrote:
> We've been ineffectively trying to split them between target and
> initiator, since it's effectively both.  Now that we seem to have a
> workable process, why don't we just take everything (target scsi-queue
> and vhost) through the SCSI tree, that way we don't get into these
> problems in future.

virtio-scsi has nothing to do with the target.  I also think sending
target updates through the scsi tree doesn't seem very useful, as there's
is no shared code to start with.
