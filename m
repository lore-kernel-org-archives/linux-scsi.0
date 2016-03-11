From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] megaraid_sas: Don't issue kill adapter for MFI controllers in case of PD list DCMD failure
Date: Thu, 10 Mar 2016 20:29:15 -0500
Message-ID: <yq1r3fhn6ok.fsf@sermon.lab.mkp.net>
References: <1457604877-5280-1-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48503 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933051AbcCKBaB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2016 20:30:01 -0500
In-Reply-To: <1457604877-5280-1-git-send-email-sumit.saxena@broadcom.com>
	(Sumit Saxena's message of "Thu, 10 Mar 2016 02:14:37 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: thenzl@redhat.com, jbottomley@parallels.com, martin.petersen@oracle.com, hch@infradead.org, linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com

>>>>> "Sumit" == Sumit Saxena <sumit.saxena@broadcom.com> writes:

Sumit> There are few MFI adapters which do not support
Sumit> MR_DCMD_PD_LIST_QUERY so if MFI adapters fail this DCMD, it
Sumit> should not be considered as FATAL and driver should not issue
Sumit> kill adapter and set per controller's instance variable-
Sumit> pd_list_not_supported so that same variable can be used inside
Sumit> functions- slave_alloc and slave_configure to allow firmware
Sumit> scan.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
