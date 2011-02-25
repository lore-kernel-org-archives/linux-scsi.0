From: adam radford <aradford@gmail.com>
Subject: [PATCH 0/14] megaraid_sas: Updates for scsi-misc-2.6
Date: Thu, 24 Feb 2011 20:55:46 -0800
Message-ID: <AANLkTi=xmfO_ikYewyM6nSRZax7bxQosd61AR35hg2g6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63624 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1BYEzr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2011 23:55:47 -0500
Received: by wwb39 with SMTP id 39so1695813wwb.1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2011 20:55:46 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

James/Linux-scsi,

The following patch series for megaraid_sas has been re-based on scsi-misc-2.6.

1. Fix failure gotos.
2. Add missing check_and_restore_queue_depth call.
3. Enable MSI-X before calling megasas_init_fw.
4. Call tasklet_schedule for MSI-X.
5. Fix probe_one to clear MSI-X flags in kdump.
6. Fix megasas_get_cmd printk.
7. Fix megasas_build_dcdb_fusion to not filter by TYPE_DISK.
8. Fix megasas_build_dcdb_fusion to use correct LUN field.
9. Add CFG_CLEARED AEN.
10. Fix tasklet_init call.
11. Fix fault state handling.
12. Fix max_sectors for IEEE SGL.
13. Fix iMR OCR support to work.
14. Version and Changelog update.

-Adam
