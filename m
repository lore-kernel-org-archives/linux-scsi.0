From: <nagalakshmi.nandigama@lsi.com>
Subject: [RESEND] [PATCH] [SCSI] mpt2sas : Description Patch
Date: Tue, 20 Mar 2012 11:57:05 +0530
Message-ID: <201203200626.q2K6QYJQ030362@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:41614 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754546Ab2CTG0h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2012 02:26:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: jejb@kernel.org

Please consider this patch set for next kernel release.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---

[PATCH 01/12] [SCSI] mpt2sas : MPI next revision header update
[PATCH 02/12] [SCSI] mpt2sas : Removed redundant global mutex for IOCTLs.
[PATCH 03/12] [SCSI] mpt2sas : Added multisegment mode support for Linux BSG Driver.
[PATCH 04/12] [SCSI] mpt2sas : Perform Target Reset instead of HBA reset when a SATA_PASSTHROUGH cmd timeout happens.
[PATCH 05/12] [SCSI] mpt2sas : Improvement were made to better protect the sas_device, raid_device, and expander_device lists.
[PATCH 06/12] [SCSI] mpt2sas : Fix security scan issues reported by source code analysis tool
[PATCH 07/12] [SCSI] mpt2sas : Fix linux driver sparse errors 
[PATCH 08/12] [SCSI] mpt2sas : While enabling phy, read the current port number from sas iounit page 0 instead of page 1.
[PATCH 09/12] [SCSI] mpt2sas : Set the phy identifier of the end device to the phy number of the parent device it is linked to. 
[PATCH 10/12] [SCSI] mpt2sas : Fix for hard drive going OFFLINE when hard reset issued and simultaneously another hard drive is hot unplugged.
[PATCH 11/12] [SCSI] mpt2sas : Fix for panic happening because of improper memory allocation
[PATCH 12/12] [SCSI] mpt2sas : Bump driver vesion to 13.100.00.00

The above patches are built by applying the following patches 
1) [PATCH] mpt2sas: Corrected the constant in comparison to a hexadecimal