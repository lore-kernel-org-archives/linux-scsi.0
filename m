From: Lukas Herbolt <lherbolt@redhat.com>
Subject: Fwd: All scsi_debug devices in the scsi_debug driver share the same
 RAM space
Date: Mon, 12 Feb 2018 16:04:59 +0100
Message-ID: <CAM4Jq_5yHhEWU6hvUfJVnCpyCk0QPMHhZ7cY3Eum540124ukeQ@mail.gmail.com>
References: <1517686992.18584.8.camel@redhat.com> <1517841151.11655.1.camel@redhat.com>
 <CAM4Jq_43+JrSTvXsq7kgRLikqHb2iwFMYKTBuQjQ5h2Dn1ka+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:45520 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751176AbeBLPFk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2018 10:05:40 -0500
Received: by mail-qt0-f174.google.com with SMTP id x27so19199718qtm.12
        for <linux-scsi@vger.kernel.org>; Mon, 12 Feb 2018 07:05:40 -0800 (PST)
In-Reply-To: <CAM4Jq_43+JrSTvXsq7kgRLikqHb2iwFMYKTBuQjQ5h2Dn1ka+A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
I like the idea to have an option to separate the memory area for
different LUNs, while keeping the current behavior as default.

Lukas
