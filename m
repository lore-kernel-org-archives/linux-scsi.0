From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151661] Adaptec 3405 3805 prints "AAC: Host adapter dead -1"
 every 10 seconds but works fine anyway
Date: Mon, 22 Aug 2016 21:52:53 +0000
Message-ID: <bug-151661-11613-13r7gGKwdd@https.bugzilla.kernel.org/>
References: <bug-151661-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755668AbcHVVw6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Aug 2016 17:52:58 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 255D52028D
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2016 21:52:57 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 6FC4D202FE
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2016 21:52:54 +0000 (UTC)
In-Reply-To: <bug-151661-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151661

--- Comment #9 from Piotr Szymaniak <bugzie@grubelek.pl> ---
Created attachment 229741
  --> https://bugzilla.kernel.org/attachment.cgi?id=229741&action=edit
dmesg vanilla 4.3.6 (with Alex patch)

I tried previous vanilla kernels 4.x.latest-released and, as 4.6.x prints
messages over and over I skipped 4.5 series and tried:
- 4.4.19 - prints dead messages
- 4.3.6 - works without messages (with Alex patch [1], intel_iommu=igfx_off)

Not sure if this helps, but I hope it will. Any suggestions how to proceed from
here?

[1] https://www.redhat.com/archives/vfio-users/2016-July/msg00063.html

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
