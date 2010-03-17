From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/11] mpt2sas : Description patch
Date: Wed, 17 Mar 2010 16:20:55 +0530
Message-ID: <20100317105042.GA21264@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:37088 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754311Ab0CQLWA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2010 07:22:00 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


MPT2SAS driver updates.
Please consider it for next Merge window.
patch is taken using 2.6.33-rc7. Base driver for this patch is 04.100.01.02.
Before applying this patchset previous patch submission for 04.100.01.02
need to be applied.

[PATCH 01/11] mpt2sas: Corrected time stamp
[PATCH 02/11] mpt2sas: Corrected conditional checks for Internal device
			Reset
[PATCH 03/11] mpt2sas: Use of get_free_pages for huge memorary allocation.
[PATCH 04/11] mpt2sas: Early return from function if shost is in recovery.
[PATCH 05/11] mpt2sas: Driver will not treat NEEDS_INIT as failure.
[PATCH 06/11] mpt2sas: Fix for little endian.
[PATCH 07/11] mpt2sas: removed use of tm_cmds.mutex in IOCTL branch.
[PATCH 08/11] mpt2sas: return -ENOMEM if memory allocation failed.
[PATCH 09/11] mpt2sas: Default descriptor for RAID Passthru command.
[PATCH 10/11] mpt2sas: Copyright 2010.
[PATCH 11/11] mpt2sas: Bump version 05.100.00.00

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
