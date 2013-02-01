From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH] [SCSI] mpt2sas: Description patch
Date: Fri, 1 Feb 2013 21:46:41 +0530
Message-ID: <20130201161641.GA21513@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:43674 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918Ab3BAFWr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2013 00:22:47 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, sreekanth.reddy@lsi.com, Nagalakshmi.Nandigama@lsi.com, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, sathya.prakash@lsi.com

Please consider this patch set for next kernel release.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---

[PATCH 1/8] [SCSI] mpt2sas : Add support for OEM specific controller.
[PATCH 2/8] [SCSI] mpt2sas : Fix for issue Missing delay not getting set during system bootup.
[PATCH 3/8] [SCSI] mpt2sas : MPI2 Rev W (2.00.15) specification.
[PATCH 4/8] [SCSI] mpt2sas : Update the timing requirements for issuing a Hard Reset as per the MPI spec.
[PATCH 5/8] [SCSI] mpt2sas : Fix for device scan following host reset could get stuck in a infinite loop.
[PATCH 6/8] [SCSI] mpt2sas : When SCSI command is received with task atrribute not set, set it to SIMPLE.
[PATCH 7/8] [SCSI] mpt2sas : Calulate the Reply post queue depth calculation as per the MPI spec.
[PATCH 8/8] [SCSI] mpt2sas : Bump driver vesion to v15.100.00.00.
