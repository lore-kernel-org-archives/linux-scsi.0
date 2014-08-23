From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH V5 0/5] Add XEN pvSCSI support
Date: Fri, 22 Aug 2014 20:40:42 -0400
Message-ID: <20140823004042.GA5547@laptop.dumpdata.com>
References: <1408354310-6362-1-git-send-email-jgross@suse.com>
 <1408742515.24496.21.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1408742515.24496.21.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: jgross@suse.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 22, 2014 at 02:21:55PM -0700, Nicholas A. Bellinger wrote:
> Hi Juergen & Co,
> 
> On Mon, 2014-08-18 at 11:31 +0200, jgross@suse.com wrote:
> > This series adds XEN pvSCSI support. With pvSCSI it is possible to use physical
> > SCSI devices from a XEN domain.
> > 
> > The support consists of a backend in the privileged Domain-0 doing the real
> > I/O and a frontend in the unprivileged domU passing I/O-requests to the backend.
> > 
> > The code is taken (and adapted) from the original pvSCSI implementation done
> > for Linux 2.6 in 2008 by Fujitsu.
> > 
> > [PATCH V5 1/5] xen/events: support threaded irqs for interdomain event channels
> > [PATCH V5 2/5] Add XEN pvSCSI protocol description
> > [PATCH V5 3/5] Introduce xen-scsifront module
> > [PATCH V5 4/5] Introduce XEN scsiback module
> > [PATCH V5 5/5] add xen pvscsi maintainer
> > 
> > Changes in V5:
> > - Added patch to support threaded irqs for interdomain event channels
> > - several changes in xen-scsifront after comments from Christoph Hellwig
> > - several changes in xen-scsiback after comments from Christoph Hellwig
> > - several changes in xen-scsiback after comments from James Bottomley
> > 
> > Changes in V4:
> > - Re-add define for VSCSIIF_ACT_SCSI_SG_PRESET to vscsiif.h to indicate this
> >   action value should not be used in future enhancements
> > 
> > Changes in V3:
> > - added some comments to the protocol header file
> > - removed the CDB emulation from xen-scsiback, handled by core target
> >   infrastructure
> > - several changes in xen-scsifront after comments from Christoph Hellwig
> > 
> > Changes in V2:
> > - use core target infrastructure by backend instead of pure SCSI passthrough
> > - add support for larger SG lists by putting them in grant page(s)
> > - add command abort capability
> > 
> 
> For the XEN scsiback parts as a new target fabric driver, feel free to
> add my:
> 
> Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> So I assume this will be merged for v3.18 via the xen.git tree, yes..?

<nods>
When I chatted with Christopher Hellwig he recommended it be done that way.

I am almost done with the Xen bits.
> 
> --nab
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
