From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH][SCSI] mpt3sas: Description patch
Date: Sat, 29 Jun 2013 03:49:54 +0530
Message-ID: <20130628221954.GA5033@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:39495
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755306Ab3F1LYg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jun 2013 07:24:36 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com


Please consider this patch set fot next kernel release.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---

[PATCH 1/7][SCSI] mpt3sas: 2013 source code copyright.
[PATCH 2/7][SCSI] mpt3sas: Updated the Hardware timing requirements.
[PATCH 3/7][SCSI] mpt3sas: fix for kernel panic when driver loads with HBA conected to non LUN 0 configured expander.
[PATCH 4/7][SCSI] mpt3sas: Infinite loops can occur if MPI2_IOCSTATUS_CONFIG_INVALID_PAGE is not returned.
[PATCH 5/7][SCSI] mpt3sas: MPI2.5 Rev F v2.5.1.1 specification.
[PATCH 6/7][SCSI] mpt3sas: when async scanning is enabled then while scanning, devices are removed but their transport layer entries are not removed.
[PATCH 7/7][SCSI] mpt3sas: Bump driver version to v02.100.00.00.

