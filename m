From: Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] target updates for v3.16-rc1
Date: Fri, 13 Jun 2014 15:39:01 +0200
Message-ID: <20140613133901.GC7371@lst.de>
References: <1402607116.18202.46.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47787 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbaFMNjI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2014 09:39:08 -0400
Content-Disposition: inline
In-Reply-To: <1402607116.18202.46.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Paolo Bonzini <pbonzini@redhat.com>, Quinn Tran <quinn.tran@qlogic.com>, "Michael S. Tsirkin" <mst@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Christoph Hellwig <hch@lst.de>

On Thu, Jun 12, 2014 at 02:05:16PM -0700, Nicholas A. Bellinger wrote:
> The first is with virtio-scsi between what has been merged in scsi.git
> for "virtio_scsi: use cmd_size", and the "virtio-scsi: Enable DIF/DIX
> modes in SCSI host LLD" below.  (Adding Paolo + hch CC')

Just curious, why did we decide to take the virtio-scsi patches
through the target tree?  Seems like taking them through the scsi
tree would have been a lot simpler.

