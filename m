From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RESEND][PATCH][SCSI] mpt2sas: Fix for issue - Unable to boot
 from the drive connected to HBA
Date: Mon, 17 Sep 2012 13:50:14 +0100
Message-ID: <1347886214.2397.23.camel@dabdike.int.hansenpartnership.com>
References: <20120822112513.GA4720@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46765 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753786Ab2IQMuS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Sep 2012 08:50:18 -0400
In-Reply-To: <20120822112513.GA4720@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sreekanth.reddy@lsi.com
Cc: linux-scsi@vger.kernel.org, jejb@kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, stable@vger.kernel.org

On Wed, 2012-08-22 at 16:55 +0530, sreekanth.reddy@lsi.com wrote:
> Fix for issue - Unable to boot from the SAS drive connected to HBA
> 
> This patch checks whether HBA is SAS2008 B0 controller.
> if it is a SAS2008 B0 controller then it use IO-APIC interrupt instead of MSIX,
> as SAS2008 B0 controller doesn't support MSIX interrupts.
> 
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@lsi.com>
> Cc: <stable@kernel.org>

Checkpatch, next time, please!  This has a nasty case of spaces
converted to tabs:

ERROR: code indent should use tabs where possible
#24: FILE: drivers/scsi/mpt2sas/mpt2sas_base.c:1213:
+           if it is SAS2008 B0 controller use IO-APIC instead of MSIX
*/$

ERROR: code indent should use tabs where possible
#25: FILE: drivers/scsi/mpt2sas/mpt2sas_base.c:1214:
+        if (ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2008 &&$

WARNING: please, no spaces at the start of a line
#25: FILE: drivers/scsi/mpt2sas/mpt2sas_base.c:1214:
+        if (ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2008 &&$

ERROR: code indent should use tabs where possible
#26: FILE: drivers/scsi/mpt2sas/mpt2sas_base.c:1215:
+            ioc->pdev->revision == 0x01) {$

WARNING: please, no spaces at the start of a line
#26: FILE: drivers/scsi/mpt2sas/mpt2sas_base.c:1215:
+            ioc->pdev->revision == 0x01) {$

ERROR: code indent should use tabs where possible
#27: FILE: drivers/scsi/mpt2sas/mpt2sas_base.c:1216:
+                return -EINVAL;$

WARNING: please, no spaces at the start of a line
#27: FILE: drivers/scsi/mpt2sas/mpt2sas_base.c:1216:
+                return -EINVAL;$

ERROR: code indent should use tabs where possible
#28: FILE: drivers/scsi/mpt2sas/mpt2sas_base.c:1217:
+        }$

WARNING: please, no spaces at the start of a line
#28: FILE: drivers/scsi/mpt2sas/mpt2sas_base.c:1217:
+        }$

total: 5 errors, 4 warnings, 13 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

James


