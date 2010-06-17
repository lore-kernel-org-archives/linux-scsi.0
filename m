From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/17] mpt2sas: Description Patch
Date: Thu, 17 Jun 2010 13:17:26 +0530
Message-ID: <20100617074718.GA28921@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:57552 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932514Ab0FQIXF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 04:23:05 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Eric.Moore@lsi.com, James.Bottomley@HansenPartnership.com, Sathya.Prakash@lsi.com


MPT2SAS driver changes.
These patches are taken from 2.6.35-rc2.
Please consider this patch set for next kernel release.

[PATCH 01/17] mpt2sas: Fix to use sas device list instead of enclosure list
for _transpor_get_enclosure_identifier.
[PATCH 02/17] mpt2sas: Hold Controller reset when another reset is in
progress.
[PATCH 03/17] mpt2sas: staged device discovery. disable_discovery module
parameter is added.
[PATCH 04/17] mpt2sas: Added expander phy counter support
[PATCH 05/17] mpt2sas: Added expander phy control support
[PATCH 06/17] mpt2sas: Added sysfs counter for ioc reset
[PATCH 07/17] mpt2sas: MPI header version N is updated.
[PATCH 08/17] mpt2sas: Added sysfs support for trace buffer
[PATCH 09/17] mpt2sas: print level KERN_DEBUG is replaced by KERN_INFO
[PATCH 10/17] mpt2sas: Tie a log info message to a specific PHY.
[PATCH 11/17] mpt2sas: Redesign Raid devices event handling using pd_handles
per HBA.
[PATCH 12/17] mpt2sas: Added -ENOMEM return type when allocation fails
[PATCH 13/17] mpt2sas: Add additional check for responding volumes after
Host Reset
[PATCH 14/17] mpt2sas: Adding additional message to error escalation
callback.
[PATCH 15/17] mpt2sas: Copy sense buffer instead of working on direct memory
location
[PATCH 16/17] mpt2sas: Copy message frame before releasing to free pool to
have a local reference.
[PATCH 17/17] mpt2sas: Bump version 06.100.00.00
---
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
