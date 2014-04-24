From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v2 RESEND 00/23] scsi: Use pci_enable_msix_range()
 instead of pci_enable_msix()
Date: Thu, 24 Apr 2014 17:51:09 +0000
Message-ID: <1398361868.6766.0.camel@dabdike>
References: <cover.1397461652.git.agordeev@redhat.com>
	 <20140424170903.GA29593@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140424170903.GA29593@google.com>
Content-Language: en-US
Content-ID: <44F943ECC85CD344BA81712E0FED9580@sw.swsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "bhelgaas@google.com" <bhelgaas@google.com>
Cc: "DL-MPTFusionLinux@lsi.com" <DL-MPTFusionLinux@lsi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "intel-linux-scu@intel.com" <intel-linux-scu@intel.com>, "iss_storagedev@hp.com" <iss_storagedev@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, "qla2xxx-upstream@qlogic.com" <qla2xxx-upstream@qlogic.com>, "agordeev@redhat.com" <agordeev@redhat.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "support@lsi.com" <support@lsi.com>, "iscsi-driver@qlogic.com" <iscsi-driver@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-04-24 at 11:09 -0600, Bjorn Helgaas wrote:
> On Mon, Apr 14, 2014 at 10:05:24AM +0200, Alexander Gordeev wrote:
> > Hello,
> > 
> > This series is against 3.15-rc1.
> > 
> > As result of deprecation of MSI-X/MSI enablement functions
> > pci_enable_msix() and pci_enable_msi_block() all drivers
> > using these two interfaces need to be updated to use the
> > new pci_enable_msi_range()  or pci_enable_msi_exact()
> > and pci_enable_msix_range() or pci_enable_msix_exact()
> > interfaces.
> 
> Hi James,
> 
> These depend on f7fc32c, which appeared in v3.15-rc1.  I had intended
> to merge these scsi updates at the same time, but I failed.  Would you
> like to take them now that f7fc32c is upstream?

OK, will add them.  I'm planning to base the scsi-misc tree on -rc3 once
we have our current crop of fixes upstream.

James
