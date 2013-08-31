From: adam radford <aradford@gmail.com>
Subject: [PATCH 0/2] megaraid_sas: Updates for scsi-misc
Date: Sat, 31 Aug 2013 16:54:08 -0700
Message-ID: <CAHtARFH_e1z2=y-TqBpTwbcLw4XTHCKrfiebvt4SupV0kva3XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:54262 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab3HaXyJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Aug 2013 19:54:09 -0400
Received: by mail-qc0-f170.google.com with SMTP id i8so1860170qcq.1
        for <linux-scsi@vger.kernel.org>; Sat, 31 Aug 2013 16:54:08 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Kashyap Desai <Kashyap.Desai@lsi.com>

James/linux-scsi,

The following small patch series for megaraid_sas brings the driver up
to v06.700.06.00-rc1:

1. Add High Availability clustering support using shared Logical Disks.
2. Version and Changelog update.

-Adam
