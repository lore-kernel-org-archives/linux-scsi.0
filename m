From: adam radford <aradford@gmail.com>
Subject: [PATCH 0/4] megaraid_sas: Updates for scsi-misc
Date: Fri, 6 Jan 2012 17:01:39 -0800
Message-ID: <CAHtARFEimZeSaxBM3QrBdzfM6Hzvzvc-94S15tW5=JUa2DS6tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58644 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab2AGBBl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2012 20:01:41 -0500
Received: by werm1 with SMTP id m1so1502252wer.19
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jan 2012 17:01:40 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

James/linux-scsi,

The following patch series for megaraid_sas brings the driver up to v6.14-rc1:

1. Fix reglockFlags for degraded raid5/6 for MR 9360/9380.
2. Mask off flags in ioctl path to prevent memory scribble with older
MegaCLI versions.
3. Remove poll_mode_io module parameter, sysfs node, and associated code.
4. Version and Changelog update.

-Adam
