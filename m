From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 0/9] Phase out pci_enable_msi_block()
Date: Fri, 17 Jan 2014 14:00:32 -0700
Message-ID: <CAErSpo5ztnyyceeN38XzLasLV6eJqdbqEV0viPp3Af8U=ts23w@mail.gmail.com>
References: <cover.1389904166.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <cover.1389904166.git.agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Brian King <brking@us.ibm.com>, Tejun Heo <tj@kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Alex Williamson <alex.williamson@redhat.com>, Kalle Valo <kvalo@qca.qualcomm.com>, Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>, linux-wireless <linux-wireless@vger.kernel.org>, wil6210@qca.qualcomm.com, ath10k@lists.infradead.org, linux-nvme@lists.infradead.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 17, 2014 at 9:02 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> This series is against "next" branch in Bjorn's repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git
>
> Changes from v1 to v2:
>   - added a regression fix "ahci: Fix broken fallback to single
>     MSI mode" as patch 1/9;
>   - the series is reordered to move the regression fix in front;
>   - at Bjorn's request pci_enable_msi() is un-deprecated;
>   - as result, pci_enable_msi_range(pdev, 1, 1) styled calls
>     rolled back to pci_enable_msi(pdev);
>   - nvme bug fix moved out as a separate patch 5/9 "nvme: Fix
>     invalid call to irq_set_affinity_hint()"
>   - patches changelog elaborated a bit;
>
> Bjorn,
>
> As the release is supposedly this weekend, do you prefer
> the patches to go to your tree or to individual trees after
> the release?

I'd be happy to merge them, except for the fact that they probably
wouldn't have any time in -next before I ask Linus to pull them.  So
how about if we wait until after the release, ask the area maintainers
to take them, and if they don't take them, I'll put them in my tree
for v3.15?

Bjorn
