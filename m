From: Masoud Sharbiani <msharbiani@twitter.com>
Subject: Backport of a fix for a race condition in HPSA driver
Date: Fri, 14 Nov 2014 10:53:55 -0800
Message-ID: <CAJVGYjpRXcuZ7SjGiWF1_cQ-t4UFmRQ7H3o=bZ6wW+j-QbfJwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:63589 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965567AbaKNSx4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 13:53:56 -0500
Received: by mail-la0-f45.google.com with SMTP id pn19so15639641lab.18
        for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2014 10:53:55 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stable@vger.kernel.org
Cc: thenzl@redhat.com, scameron@beardog.cce.hp.com, JBottomley@parallels.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org

Hello stable maintainers,
Can you please backport commitid
2cc5bfaf854463d9d1aa52091f60110fbf102a9 ([SCSI] hpsa: fix a race in
cmd_free/scsi_done) to 3.10 stable (and earlier, if applicable)? It
seems to fix an issue that we have run into a couple of times.

Many thanks,
Masoud Sharbiani
