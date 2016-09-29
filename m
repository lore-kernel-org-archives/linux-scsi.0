From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 4/6] vfio_pci: use pci_irq_allocate_vectors
Date: Thu, 29 Sep 2016 13:27:35 -0600
Message-ID: <20160929132735.25f20db7@t450s.home>
References: <1473600688-24043-1-git-send-email-hch@lst.de>
        <1473600688-24043-5-git-send-email-hch@lst.de>
        <20160929132101.248d79c0@t450s.home>
        <20160929192404.GA4964@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20160929192404.GA4964@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: hans.verkuil@cisco.com, brking@us.ibm.com, haver@linux.vnet.ibm.com, ching2048@areca.com.tw, axboe@fb.com, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-media@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 29 Sep 2016 21:24:04 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Thu, Sep 29, 2016 at 01:21:01PM -0600, Alex Williamson wrote:
> > Sorry for the delay, slipped by me.  Overall a really nice cleanup.
> > One tiny nit, the commit log mis-names the function as
> > pci_irq_allocate_vectors instead of pci_alloc_irq_vectors.  With that,
> > 
> > Acked-by: Alex Williamson <alex.williamson@redhat.com>
> > 
> > Let me know if you're wanting me to pull this through my tree, I'm
> > assuming not.  Thanks,  
> 
> Please pull in through your tree.  If you can also just fix up that
> type that'd be even better.

Will do.  Thanks,

Alex
