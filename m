From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V3 2/2] scsi: ufshcd-intel-pci: Add PCI driver for Intel
 Host controllers
Date: Tue, 6 Jun 2017 03:10:34 -0700
Message-ID: <20170606101034.GA20599@infradead.org>
References: <20170606070757.GA1748@infradead.org>
 <1496740136-4024-1-git-send-email-adrian.hunter@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1496740136-4024-1-git-send-email-adrian.hunter@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Szymon Mielczarek <szymonx.mielczarek@intel.com>, Michal Potomski <michalx.potomski@intel.com>, Grzegorz Janca <grzegorz.janca@intel.com>
List-Id: linux-scsi@vger.kernel.org


This looks much better.  But the new file still looks almost like
a copy and paste of tc-dwc-g210-pci.c.  Wouldnt it make more sense to
start with a common ufshcd-pci driver that sets up the ufs_hba_variant_opsA
based on the PCI ID table?

Also given that this almost entitrely a copy & paste job of
tc-dwc-g210-pci.c. you should add the copyrights and following their
license.
