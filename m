From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH v2 RESEND 00/23] scsi: Use pci_enable_msix_range()
 instead of pci_enable_msix()
Date: Mon, 16 Jun 2014 09:35:56 +0200
Message-ID: <20140616073556.GA359@dhcp-26-207.brq.redhat.com>
References: <cover.1397461652.git.agordeev@redhat.com>
 <20140424170903.GA29593@google.com>
 <1398361868.6766.0.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1398361868.6766.0.camel@dabdike>
Sender: linux-pci-owner@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "bhelgaas@google.com" <bhelgaas@google.com>, "DL-MPTFusionLinux@lsi.com" <DL-MPTFusionLinux@lsi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "intel-linux-scu@intel.com" <intel-linux-scu@intel.com>, "iss_storagedev@hp.com" <iss_storagedev@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, "qla2xxx-upstream@qlogic.com" <qla2xxx-upstream@qlogic.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "support@lsi.com" <support@lsi.com>, "iscsi-driver@qlogic.com" <iscsi-driver@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 24, 2014 at 05:51:09PM +0000, James Bottomley wrote:
> > These depend on f7fc32c, which appeared in v3.15-rc1.  I had intended
> > to merge these scsi updates at the same time, but I failed.  Would you
> > like to take them now that f7fc32c is upstream?
> 
> OK, will add them.  I'm planning to base the scsi-misc tree on -rc3 once
> we have our current crop of fixes upstream.

Hi James,

If I need to repost the series to get it into you tree?

Thanks!

> James
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
