From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 00/06] mptfusion : (Resend) Description patch
Date: Thu, 10 Feb 2011 11:47:53 +0530
Message-ID: <20110210061746.GA31424@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:39972 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750997Ab1BJHEc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2011 02:04:32 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


MPT Fusion driver updates. Please consider it for next rc update.

Resending patch set. Corrected posting to stable kernel as requested by
Greg and following correct process of posting patches to stable kernel.

First three patches are New  Feature/Optimization. Patch 4,5 are Fixes.
Removed sas_address sysfs addition as commented by James from patch-1.

[PATCH 01/06] mptfusion: (New Feature)Added new sysfs parameters for handle
and haldles.
[PATCH 02/06] mptfusion: (New Feature)Support SAS2.0 Devices with SAS1.0 Controllers
[PATCH 03/06] mptfusion: (Optmization)Remove bus reset for mptsas module
[PATCH 04/06] mptfusion: (Fix) mptctl_release is required in mptctl.c
[PATCH 05/06] mptfusion: (Fix) Incorrect return value in mptscsih_dev_reset
[PATCH 06/06] mptfusion: Bump version 03.04.18

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
