From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH v2 00/23] scsi: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Date: Tue, 25 Feb 2014 09:37:08 +0100
Message-ID: <20140225083708.GB2794@dhcp-26-207.brq.redhat.com>
References: <cover.1393191330.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1393191330.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: iss_storagedev@hp.com, intel-linux-scu@intel.com, support@lsi.com, DL-MPTFusionLinux@lsi.com, qla2xxx-upstream@qlogic.com, iscsi-driver@qlogic.com, pv-drivers@vmware.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 24, 2014 at 09:02:00AM +0100, Alexander Gordeev wrote:
> This series is against James Bottomley's SCSI tree [1], but it needs
> commit f7fc32c ("PCI/MSI: Add pci_enable_msi_exact() and
> pci_enable_msix_exact()") from from Bjorn Helgaas's PCI tree [2]:

The prerequisite commit 3ce4e86 is in 3.14-rc4 now.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
