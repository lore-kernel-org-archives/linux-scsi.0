From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] Introduce XEN scsiback module
Date: Fri, 11 Jul 2014 02:04:34 -0700
Message-ID: <20140711090434.GA533@infradead.org>
References: <1403879676-25431-1-git-send-email-jgross@suse.com>
 <1403879676-25431-4-git-send-email-jgross@suse.com>
 <20140628180953.GA10820@infradead.org>
 <53BFA70E.5040203@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53BFA70E.5040203@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: Juergen Gross <jgross@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, JBottomley@parallels.com, linux-scsi@vger.kernel.org, xen-devel@lists.xen.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 11, 2014 at 10:57:50AM +0200, Juergen Gross wrote:
> >This should be written against the generic target core infrastructure
> >in drivers/target, instead of introducing another simplistic pass
> >through only SCSI target.
> >.
> >
> 
> Just to be sure: you mean something like a combined version of
> tcm_vhost and virtio_scsi?

It would be roughly equivalent to tcm_vhost.  virtio_scsi is the
equivanet of scsifront in Xen.
