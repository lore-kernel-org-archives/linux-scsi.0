From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH v2 0/9] Phase out pci_enable_msi_block()
Date: Sat, 18 Jan 2014 08:15:38 +0100
Message-ID: <20140118071538.GA32535@dhcp-26-207.brq.redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
 <CAErSpo5ztnyyceeN38XzLasLV6eJqdbqEV0viPp3Af8U=ts23w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAErSpo5ztnyyceeN38XzLasLV6eJqdbqEV0viPp3Af8U=ts23w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Brian King <brking@us.ibm.com>, Tejun Heo <tj@kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Alex Williamson <alex.williamson@redhat.com>, Kalle Valo <kvalo@qca.qualcomm.com>, Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>, linux-wireless <linux-wireless@vger.kernel.org>, wil6210@qca.qualcomm.com, ath10k@lists.infradead.org, linux-nvme@lists.infradead.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 17, 2014 at 02:00:32PM -0700, Bjorn Helgaas wrote:
> > As the release is supposedly this weekend, do you prefer
> > the patches to go to your tree or to individual trees after
> > the release?
> 
> I'd be happy to merge them, except for the fact that they probably
> wouldn't have any time in -next before I ask Linus to pull them.  So
> how about if we wait until after the release, ask the area maintainers
> to take them, and if they don't take them, I'll put them in my tree
> for v3.15?

Patch 11 depends on patches 1-10, so I am not sure how to better handle it.
Whatever works for you ;)

I am only concerned with a regression fix "ahci: Fix broken fallback to
single MSI mode" which would be nice to have in 3.14. But it seems pretty
much too late.

> Bjorn

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
