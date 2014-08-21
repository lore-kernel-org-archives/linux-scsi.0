From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v3 13/13] pmcraid: Use pci_enable_msix_range() instead
 of pci_enable_msix()
Date: Thu, 21 Aug 2014 13:35:55 +0200
Message-ID: <53F5D99B.2090105@redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com> <0f19a7660054e85da9f2137d21d198fbe7ddd71c.1408335523.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0f19a7660054e85da9f2137d21d198fbe7ddd71c.1408335523.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/18/2014 08:01 AM, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.

Patch looks good.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
