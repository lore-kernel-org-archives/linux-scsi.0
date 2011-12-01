From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH] [SCSI] mpt2sas: Description Patch
Date: Thu, 1 Dec 2011 07:51:43 +0530
Message-ID: <201112010928.pB19SCkl020810@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:36659 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780Ab1LAJ2T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2011 04:28:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Please consider this patch set for next kernel release.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---
[PATCH 01/08] [SCSI]  mpt2sas : Support for greater than 2TB capacity WarpDrive
[PATCH 02/08] [SCSI]  mpt2sas : Increase max transfer support from 4MB to 16MB
[PATCH 03/08] [SCSI]  mpt2sas : Added support for customer specific branding 
[PATCH 04/08] [SCSI]  mpt2sas : MPI next revision header update 
[PATCH 05/08] [SCSI]  mpt2sas : Release spinlock for the raid device list before blocking it. 
[PATCH 06/08] [SCSI]  mpt2sas : Do not retry a timed out direct IO for warpdrive
[PATCH 07/08] [SCSI]  mpt2sas : Fix for memory allocation error for large host credits
[PATCH 08/08] [SCSI]  mpt2sas : Bump driver vesion to 12.100.00.00


The above patches are built by applying the following patches 
1) [PATCH] [SCSI] mpt2sas: Fix leak on mpt2sas_base_attach() error path, Roland Dreier 
2) [PATCH] [SCSI] mpt2sas: Fix possible integer truncation of cpu_count, Roland Dreier 
3) [PATCH] [SCSI] mpt2sas: Remove unused duplicate diag_buffer_enable param, Roland Dreier 
4) [PATCH] [SCSI] mpt2sas: Use kmemdup rather than duplicating its implementation, Thomas Meyer 
5) [PATCH] [SCSI] mpt2sas: _scsih_smart_predicted_fault uses GFP_KERNEL in interrupt context, Anton Blanchard 
6) [PATCH] [SCSI] mpt2sas : Better handling DEAD IOC (PCI-E LInk down) error condition
7) [PATCH] [SCSI] mpt2sas : When IOs are terminated, update the result to DID_SOFT_ERROR
to avoid infinite resets.
8) [PATCH] [SCSI] mpt2sas : Adding support for customer specific branding.
9) [PATCH] [SCSI] mpt2sas : MPI next revision header update
10)[PATCH] [SCSI] mpt2sas : Do not set sas_device->starget to NULL from the slave_destroy callback
when all the LUNS have been deleted.
11)[PATCH] [SCSI] mpt2sas : Rearrange the the code so that the completion queues are initialized prior 
to sending the request to controller firmware.
12)[PATCH] [SCSI] mpt2sas : Bump driver version to 11.100.00.00
