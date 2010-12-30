From: Maksim Rayskiy <maksim.rayskiy@gmail.com>
Subject: [RFC] Deferred disk spinup during system resume
Date: Thu, 30 Dec 2010 11:40:10 -0800
Message-ID: <AANLkTinOqLOJ7JCpHeQNYUEirqAvkSce+eFDCGkWn3jE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46148 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab0L3TkL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Dec 2010 14:40:11 -0500
Received: by iwn9 with SMTP id 9so11169982iwn.19
        for <linux-scsi@vger.kernel.org>; Thu, 30 Dec 2010 11:40:10 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-pm@lists.linux-foundation.org

Hello,

When resuming from system suspend, scsi disks are being spun up which
takes quite a lot of time (5+ seconds in my case). The spinup is done
synchronously, so this time adds up to overall system resume time.
Ours is an embedded platform and we are using flash-based rootfs, so
there is no immediate need in harddrive after resume. What is much
more important for us is to minimize time-to-full-power. To speed up
resume, we would like to have an option to defer the spinup or run it
in parallel with system resume. I could not find any existing
mechanism to do the trick, but I might have missed something.

Can anybody comment on this?

Thanks,
Maksim.
