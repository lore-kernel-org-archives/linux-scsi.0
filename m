From: <Sumit.Saxena@lsi.com>
Subject: [PATCH 00/12] megaraid_sas : Updates for scsi for-next
Date: Wed, 22 May 2013 12:27:19 +0530
Message-ID: <201305221227.r4MCRZSP011470@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:8222 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754799Ab3EVM1n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 May 2013 08:27:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, kashyap.desai@lsi.com, aradford@gmail.com

MegaRaid driver changes.
Please consider this patch set for next kernel release.

Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
[PATCH 00/12] megaraid_sas : Updates for scsi for-next
[PATCH 01/12] megaraid_sas : Return DID_ERROR for SCSI IO, when controller is in critical h/w error.
[PATCH 02/12] megaraid_sas : Fix the interrupt mask for Gen2 controller.
[PATCH 03/12] megaraid_sas : Update balance count in driver to be in sync of firmware.
[PATCH 04/12] megaraid_sas : Free event detail memory without device ID check.
[PATCH 05/12] megaraid_sas : Set IO request timeout value provided by OS timeout for Tape devices.
[PATCH 06/12] megaraid_sas : Add support for MegaRAID Fury (device ID-0x005f) 12Gb/s controllers.
[PATCH 07/12] megaraid_sas : Add support to display Customer branding details in syslog.
[PATCH 08/12] megaraid_sas : Set IoFlags to enable Fast Path for JBODs for Invader/Fury(12 Gb/s) controllers.
[PATCH 09/12] megaraid_sas : Add support for Extended MSI-x vectors for Invader and Fury(12Gb/s HBA).
[PATCH 10/12] megaraid_sas : Add support for Uneven Span PRL11.
[PATCH 11/12] megaraid_sas : Add support to differentiate between iMR vs MR Firmware.
[PATCH 12/12] megaraid_sas : Changelog and driver version update.



