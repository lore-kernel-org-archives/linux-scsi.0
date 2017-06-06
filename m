From: Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V4 0/2] scsi: ufshcd-pci: Add Intel CNL support
Date: Tue,  6 Jun 2017 14:35:29 +0300
Message-ID: <1496748931-17162-1-git-send-email-adrian.hunter@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Subhash Jadavani <subhashj@codeaurora.org>, Santosh Yaragnavi <santosh.sy@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Szymon Mielczarek <szymonx.mielczarek@intel.com>, Michal Potomski <michalx.potomski@intel.com>, Grzegorz Janca <grzegorz.janca@intel.com>
List-Id: linux-scsi@vger.kernel.org

Hi

Here is V4 of patches to add support for Intel UFS host controllers.


Changes in V4:

	New patch "scsi: ufshcd-pci: Fix PM config"
	Do not use a separate driver for Intel

Changes in V3:

	Remove UFSHCI class code and match on PCI device ID

Changes in V2:

	Change variant name from intel to intel-pci


Adrian Hunter (2):
      scsi: ufshcd-pci: Fix PM config
      scsi: ufshcd-pci: Add Intel CNL support

 drivers/scsi/ufs/ufshcd-pci.c | 60 +++++++++++++++++++++++++++++++++----------
 1 file changed, 47 insertions(+), 13 deletions(-)


Regards
Adrian
