From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v3 10/13] csiostor: Use pci_enable_msix_range() instead
 of pci_enable_msix()
Date: Thu, 21 Aug 2014 13:15:35 +0200
Message-ID: <53F5D4D7.6000600@redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com> <3ddc5fb60e32d05996a539d7007bfb3a5e5f09b2.1408335523.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3ddc5fb60e32d05996a539d7007bfb3a5e5f09b2.1408335523.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Cc: Naresh Kumar Inna <naresh@chelsio.com>, Arvind Bhushan <arvindb@chelsio.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/18/2014 08:01 AM, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.

Patch looks good to me.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
