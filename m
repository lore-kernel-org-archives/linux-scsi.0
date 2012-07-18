From: adam radford <aradford@gmail.com>
Subject: [PATCH 0/5] megaraid_sas: Updates for scsi for-next
Date: Tue, 17 Jul 2012 18:19:37 -0700
Message-ID: <CAHtARFFU-qkPBi6k_r-7Y1T-JDbXcRdE7MzRw_pH4vnH6GQdCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40679 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2GRBTh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2012 21:19:37 -0400
Received: by yhmm54 with SMTP id m54so1074195yhm.19
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jul 2012 18:19:37 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Kashyap Desai <Kashyap.Desai@lsi.com>

James/linux-scsi,

The following patch series for megaraid_sas brings the driver up to v6.18-rc1:

1. Fix Copyright dates.
2. Add throttlequeuedepth module parameter.
3. Add resetwaittime module parameter.
4. Move poll_aen_lock initializer.
5. Version and Changelog update.

-Adam
