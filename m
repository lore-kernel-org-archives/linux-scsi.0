From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187381] 4.9.-rc4 produces hundreds of unusable scsi devices.
Date: Wed, 09 Nov 2016 20:25:02 +0000
Message-ID: <bug-187381-11613-YegGgTOrPB@https.bugzilla.kernel.org/>
References: <bug-187381-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751677AbcKIUZF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Nov 2016 15:25:05 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 01927201C8
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2016 20:25:04 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id D06A82011E
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2016 20:25:02 +0000 (UTC)
In-Reply-To: <bug-187381-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=187381

--- Comment #1 from Samuel Flory Silbory <samuel.silbory@hds.com> ---
Created attachment 244101
  --> https://bugzilla.kernel.org/attachment.cgi?id=244101&action=edit
Storcli output from system.

Note that this occurs with really old firmware and the current megaraid
firmware.  The megaraid configuration is 12 one drive RAID zero arrays.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
