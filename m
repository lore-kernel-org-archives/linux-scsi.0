From: adam radford <aradford@gmail.com>
Subject: [PATCH 0/8] megaraid_sas: Updates for scsi-misc-2.6
Date: Wed, 11 May 2011 18:33:29 -0700
Message-ID: <BANLkTik1KXrJWZ_bv--2_eA9uTXtMTUQjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:50650 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1ELBd3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 May 2011 21:33:29 -0400
Received: by qyg14 with SMTP id 14so618486qyg.19
        for <linux-scsi@vger.kernel.org>; Wed, 11 May 2011 18:33:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

James/linux-scsi,

The following patch series for megaraid_sas brings the driver up to v5.38:

1. Remove MSI-X black list, use MFI_REG_STATE.ready.msiEnable.
2. Remove un-used function megasas_return_cmd_for_smid().
3. Check MFI_REG_STATE.fault.resetAdapter in megasas_reset_fusion().
4. Disable interrupts/free_irq() in megasas_shutdown().
5. Fix bug where AENs could be lost in probe() and resume().
6. Convert 6,10,12 byte CDB's to 16 byte CDB for large LBA's for FastPath IO.
7. Add 1078 OCR suport.

-Adam
