From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/5] mptfusion : Description Patch
Date: Wed, 16 Dec 2009 19:00:15 +0530
Message-ID: <20091216133008.GM31161@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:50509 "HELO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933068AbZLPN5h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 08:57:37 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


MPT Fusion driver updates. Please consider it for next rc update.

[PATCH 1/5] mptfusion: Added MPI_SCSIIO_CONTROL_HEADOFQ priority
[PATCH 2/5] mptfusion: Added sysfs expander manufacture information
 at the time of
expander add.
[PATCH 3/5] mptfusion: block device when target is being removed by FW.
[PATCH 4/5] mptfusion: corrected if condition check for SCSIIO and PASSTHROUGH
commands
[PATCH 5/5] mptfusion: Bump version 03.04.14

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
