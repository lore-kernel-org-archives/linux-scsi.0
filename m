From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/10] mpt2sas: Description Patch
Date: Tue, 4 Jan 2011 11:30:40 +0530
Message-ID: <20110104060032.GA5751@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:57752 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750983Ab1ADGpd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2011 01:45:33 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


MPT2SAS driver changes.
These patches are taken from 2.6.37-rc5.
Please consider this patch set for next kernel release.

[PATCH 01/10] mpt2sas: Device removal handshake even though the
PHYSTATUS_VACANT bit is set in the PhyStatus
[PATCH 02/10] mpt2sas: Internal device reset complete event is not
supported for older firmware prior to MPI Rev K
[PATCH 03/10] mpt2sas: Correct resizing calculation for max_queue_depth
[PATCH 04/10] mpt2sas: Revision P MPI Header Update
[PATCH 05/10] mpt2sas: Add support for Customer specific branding messages
[PATCH 06/10] mpt2sas: Fix the race between broadcast asyn event and scsi
command completion.
[PATCH 07/10] mpt2sas: Prevent access to freed memory from port enable process
[PATCH 08/10] mpt2sas: Basic Code Cleanup in mpt2sas_base
[PATCH 09/10] mpt2sas: Call the _scsih_ir_shutdown prior to reporting the
volumes missing from the OS
[PATCH 10/10] mpt2sas: Bump version 08.100.00.00

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
