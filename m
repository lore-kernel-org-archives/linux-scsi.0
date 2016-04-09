From: Varun Prakash <varun@chelsio.com>
Subject: Re: [RFC 14/34] iscsi-target: export symbols
Date: Sat, 9 Apr 2016 17:39:12 +0530
Message-ID: <20160409120909.GA1656@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
 <4e5a7630ec492ff510404fb1ad0f011634518d04.1455467089.git.varun@chelsio.com>
 <20160301144921.GC9738@infradead.org>
 <20160302120044.GB1755@chelsio.com>
 <1457214847.28660.64.camel@haakon3.risingtidesystems.com>
 <1457392974.30747.45.camel@haakon3.risingtidesystems.com>
 <1457764113.4062.169.camel@haakon3.risingtidesystems.com>
 <20160313121354.GA1648@chelsio.com>
 <1460099803.13128.22.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460099803.13128.22.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "roland@kernel.org" <roland@kernel.org>, SWise OGC <swise@opengridcomputing.com>, Indranil Choudhury <indranil@chelsio.com>, Karen Xie <kxie@chelsio.com>, Hariprasad S <hariprasad@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 08, 2016 at 12:16:43AM -0700, Nicholas A. Bellinger wrote:
> On Sun, 2016-03-13 at 17:43 +0530, Varun Prakash wrote:
> > On Fri, Mar 11, 2016 at 10:28:33PM -0800, Nicholas A. Bellinger wrote:
> > > Hi Varun & Co,
> > > 
> > > On Mon, 2016-03-07 at 15:22 -0800, Nicholas A. Bellinger wrote:
> > > 
> > > <SNIP>
> > > 
> > > The drivers/net/ethernet/chelsio/cxgb4/ prerequisites for supporting
> > > iscsi segment offload (ISO) + page pod manager (PPM) are in
> > > target-pending/for-next-merge, and patches #13+ have been dropped
> > > for initial v4.6-rc1 merge.
> > > 
> > > Also, there haven't been any further linux-next subsystem merge failures
> > > beyond the initial t4fw_api.h conflict as reported by SFR.
> > > 
> > > https://lkml.org/lkml/2016/2/29/34
> > > 
> > > So please go ahead and post stand-alone cxgb4 driver changes for
> > > initial ISO + PPM to net-dev + target-devel, and Hariprasad should
> > > review + ack these ASAP.
> > 
> > Yes, I will post cxgb4 patch series, thanks.
> 
> Great.  Just curious how -v2 is coming along..?
> 
> I've got a few cycles over the weekend, and plan to start reviewing as
> the series hits the list.
>
 
I will post v2 series today, thanks.

> Btw, I asked Sagi to help out with review as well.
>
