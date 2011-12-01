From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH] [SCSI] mpt2sas : Description Patch
Date: Thu, 1 Dec 2011 07:41:30 +0530
Message-ID: <201112010918.pB19HxP8017883@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:48994 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689Ab1LAJSE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2011 04:18:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Please consider this patch set for next kernel release.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---
[PATCH 01/07] [SCSI] mpt2sas : Better handling DEAD IOC (PCI-E LInk down) error condition
[PATCH 02/07] [SCSI] mpt2sas : When IOs are terminated, update the result to DID_SOFT_ERROR
to avoid infinite resets.
[PATCH 03/07] [SCSI] mpt2sas : Adding support for customer specific branding.
[PATCH 04/07] [SCSI] mpt2sas : MPI next revision header update
[PATCH 05/07] [SCSI] mpt2sas : Do not set sas_device->starget to NULL from the slave_destroy callback
when all the LUNS have been deleted.
[PATCH 06/07] [SCSI] mpt2sas : Rearrange the the code so that the completion queues are initialized prior 
to sending the request to controller firmware.
[PATCH 07/07] [SCSI] mpt2sas : Bump driver version to 11.100.00.00

The above patches are built by considering the following patches 
1) [PATCH] [SCSI] mpt2sas: Fix leak on mpt2sas_base_attach() error path, Roland Dreier 
2) [PATCH] [SCSI] mpt2sas: Fix possible integer truncation of cpu_count, Roland Dreier 
3) [PATCH] [SCSI] mpt2sas: Remove unused duplicate diag_buffer_enable param, Roland Dreier 
4) [PATCH] [SCSI] mpt2sas: Use kmemdup rather than duplicating its implementation, Thomas Meyer 
5) [PATCH] [SCSI] mpt2sas: _scsih_smart_predicted_fault uses GFP_KERNEL in interrupt context, Anton Blanchard 