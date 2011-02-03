From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 00/06] mptfusion : Description Patch
Date: Thu, 3 Feb 2011 15:28:31 +0530
Message-ID: <20110203095823.GA23502@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:43073 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755929Ab1BCKov (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2011 05:44:51 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

MPT Fusion driver updates. Please consider it for next rc update.

[PATCH 01/06] mptfusion: Added new sysfs parameters for handle, sas_addr and
haldles.
[PATCH 02/06] mptfusion: Support SAS2.0 Devices with SAS1.0 Controllers
[PATCH 03/06] mptfusion: Remove bus reset for mptsas module
[PATCH 04/06] mptfusion: mptctl_release is required in mptctl.c
[PATCH 05/06] mptfusion: Fix Incorrect return value in mptscsih_dev_reset
[PATCH 06/06] mptfusion: Bump version 03.04.18

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
