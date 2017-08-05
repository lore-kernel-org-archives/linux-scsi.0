From: Christoph Hellwig <hch@lst.de>
Subject: Re: Increased memory usage with scsi-mq
Date: Sat, 5 Aug 2017 10:44:36 +0200
Message-ID: <20170805084436.GA14264@lst.de>
References: <20170804210035.GA10017@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170804210035.GA10017@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 04, 2017 at 10:00:47PM +0100, Richard W.M. Jones wrote:
> I read your slides about scsi-mq and it seems like a significant
> benefit to large machines, but could the out of the box defaults be
> made more friendly for small memory machines?

The default inumber of queues and queue depth and thus memory usage is
set by the LLDD.

Try to reduce the can_queue value in virtio_scsi and/or make sure
you use the single queue variant in your VM (which should be tunable
in qemu).
