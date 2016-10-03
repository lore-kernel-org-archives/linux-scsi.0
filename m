From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151661] Adaptec 3405 3805 prints "AAC: Host adapter dead -1"
 every 10 seconds but works fine anyway
Date: Mon, 03 Oct 2016 20:45:52 +0000
Message-ID: <bug-151661-11613-kKZJeOe4T4@https.bugzilla.kernel.org/>
References: <bug-151661-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752345AbcJCUqy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 Oct 2016 16:46:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 1A68320511
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2016 20:46:18 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 2D6BB2051C
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2016 20:45:53 +0000 (UTC)
In-Reply-To: <bug-151661-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151661

--- Comment #17 from Piotr Szymaniak <bugzie@grubelek.pl> ---
Created attachment 240661
  --> https://bugzilla.kernel.org/attachment.cgi?id=240661&action=edit
aac.patch

(In reply to Matthias from comment #14)
> you can find it in:
> drivers/scsi/aacraid/commsup.c
> in my 4.7.3 it is in Line 1700

Works as a workaround, but this is not a solution.

This is a patch that I use to use my controller. Alex patch + "STFU for logs".

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
