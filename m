From: adam radford <aradford@gmail.com>
Subject: [PATCH 0/10] megaraid_sas: Updates for scsi-misc
Date: Sat, 8 Oct 2011 18:14:19 -0700
Message-ID: <CAHtARFGh5i6M8SMqjeUnpUP=dWNdwdmDhGo+z4h4qE8r18xhWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63151 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1JIBOU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Oct 2011 21:14:20 -0400
Received: by wwf22 with SMTP id 22so7565389wwf.1
        for <linux-scsi@vger.kernel.org>; Sat, 08 Oct 2011 18:14:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

James/Linux-scsi,

The following patch series for megaraid_sas brings the driver up to v6.12-rc1:

1. Continue booting immediately if FW in FAULT at driver load time.
2. Increase default cmds per lun to 256.
3. Fix mismatch in megasas_reset_fusion() mutex lock-unlock.
4. Remove some un-necessary code.
5. Clear state change interrupts for Fusion/Invader.
6. Clear FUSION_IN_RESET before enabling interrupts.
7. Add support for MegaRAID 9360/9380 12GB/s controllers.
8. Add multiple MSI-X vector/multiple reply queue support.
9. Add driver workaround for PERC5/1068 kdump kernel panic.
10. Version and Changelog update.

-Adam
