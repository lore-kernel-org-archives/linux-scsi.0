From: <sreekanth.reddy@lsi.com>
Subject: [PATCH] [scsi] mpt2sas: Description Patch
Date: Tue, 17 Jul 2012 15:54:23 +0530
Message-ID: <20120717102423.GA7301@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:38420 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755212Ab2GQKXk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2012 06:23:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, sreekanth.reddy@lsi.com
Cc: jejb@kernel.org

Please consider this patch set for next kernel release.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@lsi.com>
---

[PATCH 01/09] [SCSI] mpt2sas : 2012 source code copyright.
[PATCH 02/09] [SCSI] mpt2sas : To include more Intel Branding.
[PATCH 03/09] [SCSI] mpt2sas : Fix for Driver oops, when loading driver with max_queue_depth command line option to a very small value.
[PATCH 04/09] [SCSI] mpt2sas : Provide sysfs attribute to report Backup Rail Monitor Status.
[PATCH 05/09] [SCSI] mpt2sas : Fix for max_sectors warning message is stating the incorrect range.
[PATCH 06/09] [SCSI] mpt2sas : MPI next revision header update.
[PATCH 07/09] [SCSI] mpt2sas : Fix for staged device discovery functionality of driver not working.
[PATCH 08/09] [SCSI] mpt2sas : Fix for With post diag reset same set of device gets added, removed and then again gets added with new target ids. 
[PATCH 09/09] [SCSI] mpt2sas : Bump driver vesion to 14.100.00.00.
