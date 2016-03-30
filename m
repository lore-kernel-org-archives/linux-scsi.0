From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/5] Fix several static checker warnings reported against the
 iSCSI kernel code
Date: Wed, 30 Mar 2016 11:26:03 -0700
Message-ID: <56FC1A3B.4040704@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0093.outbound.protection.outlook.com ([207.46.100.93]:11304
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752794AbcC3S0H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2016 14:26:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello James and Martin,

These five patches are what I came up with after analyzing the output of 
"make M=drivers/scsi W=1 C=2" for the iSCSI initiator kernel code. 
Please consider these patches for inclusion in kernel v4.7. The actual 
patches are:

0001-libiscsi-Unexport-iscsi_eh_target_reset.patch
0002-libiscsi-Remove-set-but-not-used-variables.patch
0003-scsi_transport_iscsi-Remove-set-but-not-used-variabl.patch
0004-scsi_transport_iscsi-Unexport-iscsi_is_flashnode_con.patch
0005-scsi_transport_iscsi-Declare-local-symbols-static.patch

Thanks,

Bart.
