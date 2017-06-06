From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] scsi: ufshcd-intel-pci: Add PCI driver for Intel
 Host controllers
Date: Tue, 6 Jun 2017 00:07:57 -0700
Message-ID: <20170606070757.GA1748@infradead.org>
References: <1496651815-13416-1-git-send-email-adrian.hunter@intel.com>
 <1496651815-13416-3-git-send-email-adrian.hunter@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1496651815-13416-3-git-send-email-adrian.hunter@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Szymon Mielczarek <szymonx.mielczarek@intel.com>, Michal Potomski <michalx.potomski@intel.com>, Grzegorz Janca <grzegorz.janca@intel.com>
List-Id: linux-scsi@vger.kernel.org

> +#define PCI_CLASS_STORAGE_UFSHCI 0x010901

should me move to pci_ids.h

> +
> +#define UFSHCD_INTEL_PCI_UFSHCI_DEVICE() { \
> +	.vendor      = PCI_VENDOR_ID_INTEL, \
> +	.device      = PCI_ANY_ID, \
> +	.subvendor   = PCI_ANY_ID, \
> +	.subdevice   = PCI_ANY_ID, \
> +	.class       = PCI_CLASS_STORAGE_UFSHCI, \
> +	.class_mask  = ~0, \
> +}

Please don't use a macro for this.  And matching for any possible
future intel device with the classcode looks a little sketchy to
me to be honest.
