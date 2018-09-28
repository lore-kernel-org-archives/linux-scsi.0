From: Joe Perches <joe@perches.com>
Subject: Bad MAINTAINERS pattern in section 'CXLFLASH (IBM Coherent Accelerator Processor Interface CAPI Flash) SCSI DRIVER'
Date: Fri, 28 Sep 2018 14:52:30 -0700
Message-ID: <20180928215230.29127-1-joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "Manoj N . Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R . Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Please fix this defect appropriately.

linux-next MAINTAINERS section:

	3964	CXLFLASH (IBM Coherent Accelerator Processor Interface CAPI Flash) SCSI DRIVER
	3965	M:	Manoj N. Kumar <manoj@linux.vnet.ibm.com>
	3966	M:	Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
	3967	M:	Uma Krishnan <ukrishn@linux.vnet.ibm.com>
	3968	L:	linux-scsi@vger.kernel.org
	3969	S:	Supported
	3970	F:	drivers/scsi/cxlflash/
-->	3971	F:	include/uapi/scsi/cxlflash_ioctls.h
	3972	F:	Documentation/powerpc/cxlflash.txt

Commit that introduced this:

commit 11f43ae7735a04994ef3c33295d386ef4e5529b7
 Author: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
 Date:   Wed Oct 21 15:15:22 2015 -0500
 
     MAINTAINERS: Add cxlflash driver
     
     Add stanza for cxlflash SCSI driver.
     
     Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
     Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
     Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
     Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
     Signed-off-by: James Bottomley <JBottomley@Odin.com>
 
  MAINTAINERS | 9 +++++++++
  1 file changed, 9 insertions(+)

No commit with include/uapi/scsi/cxlflash_ioctls.h found
