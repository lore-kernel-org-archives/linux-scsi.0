From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Xen-devel] [PATCH V5 0/5] Add XEN pvSCSI support
Date: Tue, 26 Aug 2014 06:55:52 -0700
Message-ID: <20140826135552.GA9464@infradead.org>
References: <1408354310-6362-1-git-send-email-jgross@suse.com>
 <1408742515.24496.21.camel@haakon3.risingtidesystems.com>
 <20140823004042.GA5547@laptop.dumpdata.com>
 <53FC5DBB.9080101@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53FC5DBB.9080101@citrix.com>
Sender: target-devel-owner@vger.kernel.org
To: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, jgross@suse.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, JBeulich@suse.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 26, 2014 at 11:13:15AM +0100, David Vrabel wrote:
> > <nods>
> > When I chatted with Christopher Hellwig he recommended it be done that way.
> 
> Did he give a reason?  The driver has more scsi bits in it than Xen bits
> really.

There's Xen core changes and a scsi initiator driver and a target driver
both depending on the core changes.  If we want to get all these in
in the same merge window without pre-merging trees the Xen tree is the
most sensible way to get it in.  I'll hapilly take patches for the
initiator driver for the following merge windows once it is in.
