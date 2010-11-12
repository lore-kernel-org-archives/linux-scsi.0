From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 00/11] mpt2sas : Description patch
Date: Sat, 13 Nov 2010 04:28:24 +0530
Message-ID: <20101112225724.GB853@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:40570 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313Ab0KLXlH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Nov 2010 18:41:07 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


MPT2SAS driver changes.
These patches are taken from 2.6.36-rc.
Please consider this patch set for next kernel release.

[PATCH 01/11] mpt2sas: Removed compiler warnnings when logging is disabled
[PATCH 02/11] mpt2sas: Added sanity check for cb_idx and smid access.
[PATCH 03/11] mpt2sas: Added loadtime parameters for IOMissingDelay and
Device missing delay parameters.
[PATCH 04/11] mpt2sas: Create a pool of chain buffer instead of dedicated
per IOs.
[PATCH 05/11] mpt2sas: Modify code to support Expander switch.
[PATCH 06/11] mpt2sas: MPI 2.0 Header updated.
[PATCH 07/11] mpt2sas: Remove code for TASK_SET_FULL from driver.
[PATCH 08/11] mpt2sas: change queue depth with reason argument more
appropriately.
[PATCH 09/11] mpt2sas: Sanity check for phy count is added using max phy
count.
[PATCH 10/11] mpt2sas: Debug string changes from target to device.
[PATCH 11/11] mpt2sas: Bump version 07.100.00.00

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
