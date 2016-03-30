From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/3] qla2xxx: Patches for kernel v4.7
Date: Wed, 30 Mar 2016 16:24:57 -0700
Message-ID: <56FC6049.3090303@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0066.outbound.protection.outlook.com ([157.56.110.66]:20352
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751816AbcC3XZD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2016 19:25:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello James and Martin,

The following three patches are what I came up with after having 
analyzed the output of a static source code analysis tool (sparse) for 
the QLogic qla2xxx driver:

0001-qla2xxx-Indicate-out-of-memory-with-ENOMEM.patch
0002-qla2xxx-Remove-set-but-not-used-variables.patch
0003-qla2xxx-Assign-names-to-the-flags-in-cmd_flags.patch

Please consider these patches for inclusion in kernel v4.7.

Thanks,

Bart.
