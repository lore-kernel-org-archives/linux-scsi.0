From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] target updates for v3.16-rc1
Date: Fri, 13 Jun 2014 10:04:04 -0700
Message-ID: <1402679044.2224.38.camel@dabdike.int.hansenpartnership.com>
References: <1402607116.18202.46.camel@haakon3.risingtidesystems.com>
	 <20140613133901.GC7371@lst.de>
	 <1402672861.2224.11.camel@dabdike.int.hansenpartnership.com>
	 <20140613164118.GA17282@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140613164118.GA17282@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Paolo Bonzini <pbonzini@redhat.com>, Quinn Tran <quinn.tran@qlogic.com>, "Michael S. Tsirkin" <mst@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-06-13 at 18:41 +0200, Christoph Hellwig wrote:
> On Fri, Jun 13, 2014 at 08:21:01AM -0700, James Bottomley wrote:
> > We've been ineffectively trying to split them between target and
> > initiator, since it's effectively both.  Now that we seem to have a
> > workable process, why don't we just take everything (target scsi-queue
> > and vhost) through the SCSI tree, that way we don't get into these
> > problems in future.
> 
> virtio-scsi has nothing to do with the target.  I also think sending
> target updates through the scsi tree doesn't seem very useful, as there's
> is no shared code to start with.

Yes, there is, that's where we get the conflicts.  The target tree
updates the current SCSI drivers with target pieces.  It's hard to
separate them out because there's usually some target tree dependency.

James
