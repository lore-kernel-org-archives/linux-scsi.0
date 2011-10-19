From: <nagalakshmi.nandigama@lsi.com>
Subject: RESEND [PATCH] mpt2sas: Description Patch
Date: Wed, 19 Oct 2011 15:35:33 +0530
Message-ID: <201110191611.p9JGBT2H025771@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:46688 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546Ab1JSQLh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2011 12:11:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Please consider this patch set for next kernel release.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---
[PATCH 01/10] mpt2sas : MPI next revision header update.
[PATCH 02/10] mpt2sas : New feature Fast Load Support.
[PATCH 03/10] mpt2sas : Fix for system hang when discovery in progress.
[PATCH 04/10] mpt2sas : Fix for issue - Failure message displayed during diag reset.
[PATCH 05/10] mpt2sas : Fix for issue - Drives not getting properly deleted if sas cable is removed 
while host reset is active.
[PATCH 06/10] mpt2sas : Fix for dead lock occurring between host_lock and sas_device_lock.
[PATCH 07/10] mpt2sas : Fix for deadlock between hot plug worker threads and host reset context.
[PATCH 08/10] mpt2sas : Fix for issue Port Reset taking long time(around 5 mins) to complete
while issued during creating a volume.
[PATCH 09/10] mpt2sas : Fix for Panic when inactive volume is tried deleting.
[PATCH 10/10] mpt2sas : Bump driver version to 10.100.00.00

