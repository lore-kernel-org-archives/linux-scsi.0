From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121531] Adaptec 7805H SAS HBA (pm80xx): hangs when writing
 >80MB at once
Date: Thu, 07 Jul 2016 16:34:31 +0000
Message-ID: <bug-121531-11613-HCS9sSYYzs@https.bugzilla.kernel.org/>
References: <bug-121531-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39362 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbcGGQef (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2016 12:34:35 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 964B720173
	for <linux-scsi@vger.kernel.org>; Thu,  7 Jul 2016 16:34:33 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id F048220165
	for <linux-scsi@vger.kernel.org>; Thu,  7 Jul 2016 16:34:31 +0000 (UTC)
In-Reply-To: <bug-121531-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=121531

--- Comment #14 from Jack Wang <xjtuwjp@gmail.com> ---
The changes are huge, hard to do it, without help from MicroSemi/PMCs side.
And I don't have hardware to test.

I've asked developer from MicroSemi to upsteam their changes, but
sadly no reply.

2016-07-07 17:36 GMT+02:00  <bugzilla-daemon@bugzilla.kernel.org>:
> https://bugzilla.kernel.org/show_bug.cgi?id=121531
>
> --- Comment #13 from Martin von Wittich <martin.von.wittich@iserv.eu> ---
> Yup, the Debian installation worked and seems to work fine so far. I manually
> installed the pm80xx-1.4.0-11068-debian64.deb package in the target system
> while I was still in the installer by chrooting to /target; then I added
> "pm80xx" to /etc/initramfs/modules (without that update-initramfs wouldn't add
> the pm80xx module, I'm not really sure why).
>
> After booting the system, I've succcessfully written ~500 GB of /dev/zero data
> into a file on an MD raid consisting of both of the disks. No error messages in
> the dmesg either.
>
> Can you include those missing changes into the official kernel, or how can we
> resolve this bug? We'll ask to the customer if we can keep the server for an
> additional two weeks for testing, so if you need me to test builds, let me
> know.
>
> --
> You are receiving this mail because:
> You are on the CC list for the bug.

-- 
You are receiving this mail because:
You are the assignee for the bug.
