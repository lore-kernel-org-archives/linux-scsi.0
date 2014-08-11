From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH v2 RESEND 17/23] pm8001: Fix invalid return when
 request_irq() failed
Date: Mon, 11 Aug 2014 10:14:15 +0200
Message-ID: <20140811081415.GK16504@dhcp-27-160.brq.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <5ecd9b80f705545c3dc85b2a4ae63a8ac3df8105.1405533479.git.agordeev@redhat.com>
 <53D79DE2.9000702@redhat.com>
 <20140729132020.GA7714@infradead.org>
 <53D7A62D.2090709@redhat.com>
 <20140729135641.GA14378@infradead.org>
 <20140729141544.GA18029@dhcp-26-207.brq.redhat.com>
 <20140729142403.GA13589@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140729142403.GA13589@infradead.org>
Sender: linux-pci-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Tomas Henzl <thenzl@redhat.com>, linux-kernel@vger.kernel.org, xjtuwjp@gmail.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 29, 2014 at 07:24:03AM -0700, Christoph Hellwig wrote:
> On Tue, Jul 29, 2014 at 04:15:45PM +0200, Alexander Gordeev wrote:
> > Hmm.. 18/23 applies with a minor fuzz against
> > git://git.infradead.org/users/hch/scsi-queue.git drivers-for-3.17
> 
> Okay, it was just git-am being goofy then.  I'll take care of it.
> 

Anything I can help with?
