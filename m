From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/10] mpt2sas : description patch
Date: Wed, 16 Dec 2009 18:47:49 +0530
Message-ID: <20091216131749.GA31161@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:57191 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756064AbZLPNpQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 08:45:16 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


MPT2SAS driver updates.
Please consider it for next Merge window.

[PATCH 1/10] mpt2sas: Delete volume before HBA detach.
[PATCH 2/10] mpt2sas: Return -ENODATA on IOCTL timeout
[PATCH 3/10] mpt2sas: User resource_size_t instead of unsigned long
[PATCH 4/10] mpt2sas: Set ioc->fwfault_debug to the cmd line option
mpt2sas_fwfault_debug.
[PATCH 5/10] mpt2sas: Use compat_ptr to setup the pointer compatibility.
[PATCH 6/10] mpt2sas: Added raid transport support
[PATCH 7/10] mpt2sas: Added phy_enable and set_phy_speed sysfs callback support.
[PATCH 8/10] mpt2sas: Update driver header to latest MPI Spec.
[PATCH 9/10] mpt2sas: Enable TLR for SSP TAPE drives (Added SAS Transport APIs)
[PATCH 10/10] mpt2sas: Bump version 04.100.01.00

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Reviewed-by: Eric Moore <eric.moore@lsi.com>
---
