From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH 00/22] scsi: Use pci_enable_msix_range()
Date: Wed, 19 Feb 2014 09:15:42 +0100
Message-ID: <20140219081541.GA26928@dhcp-26-207.brq.redhat.com>
References: <cover.1391512266.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbaBSINt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Feb 2014 03:13:49 -0500
Content-Disposition: inline
In-Reply-To: <cover.1391512266.git.agordeev@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>
Cc: pv-drivers@vmware.com, iscsi-driver@qlogic.com, qla2xxx-upstream@qlogic.com, support@lsi.com, DL-MPTFusionLinux@lsi.com, intel-linux-scu@intel.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org

On Tue, Feb 04, 2014 at 12:16:46PM +0100, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.

Hi James,

What is the process to get these patches accepted to scsi.git tree?
Should I make some extra effort besides just posting the series this way?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
