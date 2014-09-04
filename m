From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH v3 11/13] lpfc: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Date: Thu, 4 Sep 2014 14:29:39 +0100
Message-ID: <20140904132939.GA1225@agordeev.usersys.redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com>
 <e7470e484083c9eeb6b4f34f3e69e332ad5998c2.1408335523.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e7470e484083c9eeb6b4f34f3e69e332ad5998c2.1408335523.git.agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 18, 2014 at 08:01:51AM +0200, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.

James?

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
