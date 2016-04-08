From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 14/34] iscsi-target: export symbols
Date: Fri, 08 Apr 2016 00:16:43 -0700
Message-ID: <1460099803.13128.22.camel@haakon3.risingtidesystems.com>
References: <cover.1455467089.git.varun@chelsio.com>
	 <4e5a7630ec492ff510404fb1ad0f011634518d04.1455467089.git.varun@chelsio.com>
	 <20160301144921.GC9738@infradead.org> <20160302120044.GB1755@chelsio.com>
	 <1457214847.28660.64.camel@haakon3.risingtidesystems.com>
	 <1457392974.30747.45.camel@haakon3.risingtidesystems.com>
	 <1457764113.4062.169.camel@haakon3.risingtidesystems.com>
	 <20160313121354.GA1648@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160313121354.GA1648@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: Christoph Hellwig <hch@infradead.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "roland@kernel.org" <roland@kernel.org>, SWise OGC <swise@opengridcomputing.com>, Indranil Choudhury <indranil@chelsio.com>, Karen Xie <kxie@chelsio.com>, Hariprasad S <hariprasad@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2016-03-13 at 17:43 +0530, Varun Prakash wrote:
> On Fri, Mar 11, 2016 at 10:28:33PM -0800, Nicholas A. Bellinger wrote:
> > Hi Varun & Co,
> > 
> > On Mon, 2016-03-07 at 15:22 -0800, Nicholas A. Bellinger wrote:
> > 
> > <SNIP>
> > 
> > > So obviously this is going to take longer to sort out, and likely not
> > > end up being v4.6-rc1 material.  That is OK, as the end result will be
> > > better code.  :)
> > > 
> > > That said, it would make sense do the initial merge of the
> > > drivers/net/ethernet/chelsio/cxgb4/ + PPM prerequisites changes for
> > > v4.6, and as many basic prerequisites for iscsi-target for ISO as
> > > possible in the short time we have.
> > > 
> > > Wrt to drivers/net/ethernet/chelsio/cxgb4/ changes, please have person
> > > from Chelsio give their 'Reviewed-by' and 'Signed-off-by' to this
> > > initial series, and make sure they get posted as stand-alone patches
> > > ASAP to net-dev w/ DaveM in the loop.
> > > 
> > > I'm still happy to push these via target-pending/for-next-merge to get
> > > the ball rolling for post v4.6 development, as long as they have the
> > > extra reviews + signed-off-by from Chelsio folks, and DaveM doesn't have
> > > any objections.
> > > 
> > 
> > The drivers/net/ethernet/chelsio/cxgb4/ prerequisites for supporting
> > iscsi segment offload (ISO) + page pod manager (PPM) are in
> > target-pending/for-next-merge, and patches #13+ have been dropped
> > for initial v4.6-rc1 merge.
> > 
> > Also, there haven't been any further linux-next subsystem merge failures
> > beyond the initial t4fw_api.h conflict as reported by SFR.
> > 
> > https://lkml.org/lkml/2016/2/29/34
> > 
> > So please go ahead and post stand-alone cxgb4 driver changes for
> > initial ISO + PPM to net-dev + target-devel, and Hariprasad should
> > review + ack these ASAP.
> 
> Yes, I will post cxgb4 patch series, thanks.

Great.  Just curious how -v2 is coming along..?

I've got a few cycles over the weekend, and plan to start reviewing as
the series hits the list.

Btw, I asked Sagi to help out with review as well.
