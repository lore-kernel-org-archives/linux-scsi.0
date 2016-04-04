From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/5] Fix several static checker warnings reported against the iSCSI kernel code
Date: Mon, 04 Apr 2016 19:23:19 -0400
Message-ID: <yq1mvp9ez6g.fsf@sermon.lab.mkp.net>
References: <56FC1A3B.4040704@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27919 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbcDDXXe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2016 19:23:34 -0400
In-Reply-To: <56FC1A3B.4040704@sandisk.com> (Bart Van Assche's message of
	"Wed, 30 Mar 2016 11:26:03 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart> These five patches are what I came up with after analyzing the
Bart> output of "make M=drivers/scsi W=1 C=2" for the iSCSI initiator
Bart> kernel code. Please consider these patches for inclusion in kernel
Bart> v4.7. The actual patches are:

Bart> 0001-libiscsi-Unexport-iscsi_eh_target_reset.patch
Bart> 0002-libiscsi-Remove-set-but-not-used-variables.patch
Bart> 0003-scsi_transport_iscsi-Remove-set-but-not-used-variabl.patch
Bart> 0004-scsi_transport_iscsi-Unexport-iscsi_is_flashnode_con.patch
Bart> 0005-scsi_transport_iscsi-Declare-local-symbols-static.patch

Applied to 4.7/scsi-queue.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
