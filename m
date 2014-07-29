From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 RESEND 00/23] scsi: Use pci_enable_msix_range()
 instead of pci_enable_msix()
Date: Tue, 29 Jul 2014 05:38:53 -0700
Message-ID: <20140729123853.GA23629@infradead.org>
References: <cover.1405533479.git.agordeev@redhat.com>
 <20140717202820.GA16924@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140717202820.GA16924@infradead.org>
Sender: linux-pci-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, iss_storagedev@hp.com, intel-linux-scu@intel.com, support@lsi.com, DL-MPTFusionLinux@lsi.com, qla2xxx-upstream@qlogic.com, iscsi-driver@qlogic.com, pv-drivers@vmware.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 17, 2014 at 01:28:20PM -0700, Christoph Hellwig wrote:
> Can I get reviews for the patches still missing one, maybe from the
> Distro folks?  I'd like to pull in the whole things in favor of cherry
> picking the reviewed patches.

I've applied those few patches that did get a review to the
drivers-for-3.17 branch.   It still would be great if someone could help
reviewing the others.
