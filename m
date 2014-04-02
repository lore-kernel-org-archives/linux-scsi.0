From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH v2 00/23] scsi: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Date: Wed, 2 Apr 2014 13:49:32 +0200
Message-ID: <20140402114932.GB10007@dhcp-26-207.brq.redhat.com>
References: <cover.1393191330.git.agordeev@redhat.com>
 <20140313040440.GB26657@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140313040440.GB26657@google.com>
Sender: linux-pci-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-kernel@vger.kernel.org, iss_storagedev@hp.com, intel-linux-scu@intel.com, support@lsi.com, DL-MPTFusionLinux@lsi.com, qla2xxx-upstream@qlogic.com, iscsi-driver@qlogic.com, pv-drivers@vmware.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 12, 2014 at 10:04:40PM -0600, Bjorn Helgaas wrote:
> Hi James,
> 
> I think Alexander sent these to linux-scsi hoping that you would handle
> them, but I know it's a hassle because they depend on f7fc32c, which went
> in after the merge window.
> 
> I'd be glad to review these and apply them through my tree, unless you want
> to do it.  I'd like to get these merged in the v3.15 merge window so
> Alexander can move on to something else.  I haven't checked for merge
> conflicts with scsi.git yet, but I assume they'd be pretty trivial if there
> are any.

Hi Bjorn,

It has shifted to v3.16, right?

> Bjorn

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
