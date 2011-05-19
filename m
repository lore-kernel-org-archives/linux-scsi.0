From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [RFC] ib_srpt: initial .40-rc1 drivers/infiniband/ulp/srpt
 merge
Date: Thu, 19 May 2011 10:57:28 -0600
Message-ID: <20110519165728.GB12525@obsidianresearch.com>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
 <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com>
 <20110518170556.GB2595@obsidianresearch.com>
 <BANLkTimQXU0u5gtRzXsnsB=sCF-bvpY+Ag@mail.gmail.com>
 <BANLkTi==bZ0h3o5FNrg8PSJFp6F-zh5hTA@mail.gmail.com>
 <1305778694.2856.533.camel@haakon2.linux-iscsi.org>
 <BANLkTi=Xb-ypQNa3=MmwiLeE4Q9FWHnZXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTi=Xb-ypQNa3=MmwiLeE4Q9FWHnZXg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Roland Dreier <roland@purestorage.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-rmda <linux-rdma@vger.kernel.org>, Vu Pham <vu@mellanox.com>, David Dillow <dillowda@ornl.gov>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 19, 2011 at 12:40:02PM +0200, Bart Van Assche wrote:

> I'm still wondering whether it was a good idea to switch from ib<n>
> style names to port GIDs. Not only will that make it hard for users to
> match the ib<n> names already assigned to InfiniBand HCAs with target
> port names but this also deviates from the naming scheme used for any
> other Linux device. Ethernet devices e.g. appear as eth<n> in /dev
> instead of a MAC address like 00:1a:64:10:18:6f.

The ib# names returned by ip addr are already disjoint from the
namespace that is being used by SRP targets. The only choices are port
GUID or something like mlx4_0/1, the later is somewhat less
commonly used..

Is there some approach here for selecting the pkey as well?

Jason
