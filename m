From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 0/3] qla2xxx: Patches for kernel v4.7
Date: Thu, 31 Mar 2016 09:28:54 -0700
Message-ID: <56FD5046.7000509@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0071.outbound.protection.outlook.com ([157.56.110.71]:21271
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755379AbcCaQ3A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 12:29:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello James and Martin,

The following three patches are what I came up with after having 
analyzed the output of gcc and of a static source code analysis tool 
(sparse) for the QLogic qla2xxx driver:

0001-qla2xxx-Indicate-out-of-memory-with-ENOMEM.patch
0002-qla2xxx-Remove-set-but-not-used-variables.patch
0003-qla2xxx-Fix-a-compiler-warning.patch

Please consider these patches for inclusion in kernel v4.7.

The changes compared to v1 of this patch series are:
* Restored the code in patch 2/3 that sets BIT_14.
* Dropped the patch that removes the code for setting flags that are
   not checked.
* Added a patch that fixes a compiler warning.

Thanks,

Bart.
