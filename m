From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] target updates for v3.16-rc1
Date: Fri, 13 Jun 2014 08:21:01 -0700
Message-ID: <1402672861.2224.11.camel@dabdike.int.hansenpartnership.com>
References: <1402607116.18202.46.camel@haakon3.risingtidesystems.com>
	 <20140613133901.GC7371@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140613133901.GC7371@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Paolo Bonzini <pbonzini@redhat.com>, Quinn Tran <quinn.tran@qlogic.com>, "Michael S. Tsirkin" <mst@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-06-13 at 15:39 +0200, Christoph Hellwig wrote:
> On Thu, Jun 12, 2014 at 02:05:16PM -0700, Nicholas A. Bellinger wrote:
> > The first is with virtio-scsi between what has been merged in scsi.git
> > for "virtio_scsi: use cmd_size", and the "virtio-scsi: Enable DIF/DIX
> > modes in SCSI host LLD" below.  (Adding Paolo + hch CC')
> 
> Just curious, why did we decide to take the virtio-scsi patches
> through the target tree?  Seems like taking them through the scsi
> tree would have been a lot simpler.

We've been ineffectively trying to split them between target and
initiator, since it's effectively both.  Now that we seem to have a
workable process, why don't we just take everything (target scsi-queue
and vhost) through the SCSI tree, that way we don't get into these
problems in future.

James
