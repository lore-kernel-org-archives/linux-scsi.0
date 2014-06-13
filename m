From: Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] target updates for v3.16-rc1
Date: Fri, 13 Jun 2014 19:19:30 +0200
Message-ID: <20140613171930.GA20007@lst.de>
References: <1402607116.18202.46.camel@haakon3.risingtidesystems.com> <20140613133901.GC7371@lst.de> <1402672861.2224.11.camel@dabdike.int.hansenpartnership.com> <20140613164118.GA17282@lst.de> <1402679044.2224.38.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1402679044.2224.38.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Paolo Bonzini <pbonzini@redhat.com>, Quinn Tran <quinn.tran@qlogic.com>, "Michael S. Tsirkin" <mst@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 13, 2014 at 10:04:04AM -0700, James Bottomley wrote:
> Yes, there is, that's where we get the conflicts.  The target tree
> updates the current SCSI drivers with target pieces.  It's hard to
> separate them out because there's usually some target tree dependency.

That's only really the case for qla2xxx, and it's not been the major
issue here (the qla2xxx target code is fairly well isolated to start with).

The issue here is that the target tree got the DIF/DIX support for
virtio_scsi, which really should have gone in through the scsi tree.
