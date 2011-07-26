From: adam radford <aradford@gmail.com>
Subject: [PATCH 0/3] megaraid_sas: Updates for scsi-misc
Date: Tue, 26 Jul 2011 15:42:25 -0700
Message-ID: <CAHtARFGj7kzPwbQiXc-io9paaJ5acMR9yrggtQ_jSjXwkgOzYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44068 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab1GZWm0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2011 18:42:26 -0400
Received: by iyb12 with SMTP id 12so982773iyb.19
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2011 15:42:25 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

James/Linux-scsi,

The following patch series for megaraid_sas brings the driver up to v5.40-rc1:

1. Fix FastPath I/O to work on degraded raid 1.
2. Add .change_queue_depth support.
3. Version and Changelog update.

-Adam
