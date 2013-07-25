From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH][SCSI] mpt2sas: Description patch
Date: Thu, 25 Jul 2013 11:22:39 +0530
Message-ID: <20130725055239.GA29867@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:39986
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504Ab3GYFwQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jul 2013 01:52:16 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com


Please consider this patch set for next kernel release.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---

[PATCH 1/8][SCSI] mpt2sas: Null pointer deference possibility in mpt2sas_ctl_event_callback function.
[PATCH 2/8][SCSI] mpt2sas: Change in MPI2_RAID_ACTION_SYSTEM_SHUTDOWN_INITIATED notification methodology.
[PATCH 3/8][SCSI] mpt2sas: MPI2 Rev X (2.00.16) specifications.
[PATCH 4/8][SCSI] mpt2sas: The copyright in driver sources is updated for the year 2013.
[PATCH 5/8][SCSI] mpt2sas: Infinite loop can occur if MPI2_IOCSTATUS_CONFIG_INVALID_PAGE is not returned.
[PATCH 6/8][SCSI] mpt2sas: when Async scanning is enabled then while scanning, devices are removed but their transport layer entries are not removed.
[PATCH 7/8][SCSI] mpt2sas: Fix for kernel panic when driver loads with HBA connected to non LUN 0 configured expander.
[PATCH 8/8][SCSI] mpt2sas: Bump driver version to v16.100.00.00.

