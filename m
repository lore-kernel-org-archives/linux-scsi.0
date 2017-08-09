From: Christoph Hellwig <hch@lst.de>
Subject: Re: Increased memory usage with scsi-mq
Date: Wed, 9 Aug 2017 18:01:11 +0200
Message-ID: <20170809160111.GC3141@lst.de>
References: <20170804210035.GA10017@redhat.com> <20170805084436.GA14264@lst.de> <20170805092704.GD20914@redhat.com> <20170805133954.GA17694@lst.de> <20170805155103.GE20914@redhat.com> <b133b97e-9660-ba9b-51de-39fa23fce903@redhat.com> <20170807122701.GH20914@redhat.com> <ffc29e81-ff6b-7132-2e90-86b5632098fb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ffc29e81-ff6b-7132-2e90-86b5632098fb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Richard W.M. Jones" <rjones@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 07, 2017 at 03:07:48PM +0200, Paolo Bonzini wrote:
> can_queue should depend on the virtqueue size, which unfortunately can
> vary for each virtio-scsi device in theory.  The virtqueue size is
> retrieved by drivers/virtio prior to calling vring_create_virtqueue, and
> in QEMU it is the second argument to virtio_add_queue.

Why is that unfortunate?  We don't even have to set can_queue in
the host template, we can dynamically set it on per-host basis.
