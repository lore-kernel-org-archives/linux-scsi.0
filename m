From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/5] mptfusion : Description Patch
Date: Wed, 16 Dec 2009 18:59:06 +0530
Message-ID: <20091216132858.GL31161@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:50182 "HELO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932554AbZLPN42 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 08:56:28 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


MPT Fusion driver updates. Please consider it for next rc update.

[PATCH 1/5] mpt2sas: Added MPI_SCSIIO_CONTROL_HEADOFQ priority
[PATCH 2/5] mpt2sas: Added sysfs expander manufacture information at the time of
expander add.
[PATCH 3/5] mpt2sas: block device when target is being removed by FW.
[PATCH 4/5] mpt2sas: corrected if condition check for SCSIIO and PASSTHROUGH
commands
[PATCH 5/5] mpt2sas: Bump version 03.04.14

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
