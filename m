From: "joro@8bytes.org" <joro@8bytes.org>
Subject: Re: hpsa driver bug crack kernel down!
Date: Wed, 16 Apr 2014 16:13:20 +0200
Message-ID: <20140416141317.GB3627@8bytes.org>
References: <1397119587.19944.14.camel@shinybook.infradead.org>
 <1397146781.2608.46.camel@buesod1.americas.hpqcorp.net>
 <1397207932.19944.58.camel@shinybook.infradead.org>
 <1397490358.31076.6.camel@buesod1.americas.hpqcorp.net>
 <534C0AA9.5080909@linux.intel.com>
 <1397493858.31076.8.camel@buesod1.americas.hpqcorp.net>
 <1397494069.31076.9.camel@buesod1.americas.hpqcorp.net>
 <1397495030.19944.198.camel@shinybook.infradead.org>
 <20140416133739.GB3577@8bytes.org>
 <1397656723.7861.10.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1397656723.7861.10.camel@shinybook.infradead.org>
Sender: linux-pci-owner@vger.kernel.org
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bhe@redhat.com" <bhe@redhat.com>, "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "bhelgaas@google.com" <bhelgaas@google.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, "davidlohr@hp.com" <davidlohr@hp.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 16, 2014 at 01:58:44PM +0000, Woodhouse, David wrote:
> On Wed, 2014-04-16 at 15:37 +0200, joro@8bytes.org wrote:
> > What is the state of these fixes? I plan to send out a pull-request
> > before easter and hoped to include these fixes as well.
> 
> I'm travelling and was going to do some final testing and send out a
> pull request after I got home tomorrow. But since you ask...
> 
> Please pull from
> 	git://git.infradead.org/iommu-2.6.git
> 
> David Woodhouse (1):
>       iommu/vt-d: Fix get_domain_for_dev() handling of upstream PCIe bridges
> 
> Jiang Liu (2):
>       iommu/vt-d: fix memory leakage caused by commit ea8ea46
>       iommu/vt-d: fix bug in matching PCI devices with DRHD/RMRR descriptors
> 
>  drivers/iommu/dmar.c        |  3 ++-
>  drivers/iommu/intel-iommu.c | 10 +++++++---
>  2 files changed, 9 insertions(+), 4 deletions(-)

Pulled, thanks David. I will also do some additional testing before
sending it upstream.


	Joerg
