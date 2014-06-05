From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 3/6] virtio-scsi: avoid cancelling uninitialized work
 items
Date: Thu, 5 Jun 2014 03:12:23 -0700
Message-ID: <20140605101223.GB8633@infradead.org>
References: <1401881699-1456-1-git-send-email-pbonzini@redhat.com>
 <1401881699-1456-4-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1401881699-1456-4-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, JBottomley@Parallels.com, venkateshs@google.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 04, 2014 at 01:34:56PM +0200, Paolo Bonzini wrote:
> Calling the workqueue interface on uninitialized work items isn't a
> good idea even if they're zeroed. It's not failing catastrophically only
> through happy accidents.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
