From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187221] HPSA resetting logical / reset logical
Date: Wed, 16 Nov 2016 06:19:09 +0000
Message-ID: <bug-187221-11613-vsZoAXPh3W@https.bugzilla.kernel.org/>
References: <bug-187221-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752472AbcKPGTN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Nov 2016 01:19:13 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id C525B203B6
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2016 06:19:11 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 68C9C203B7
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2016 06:19:09 +0000 (UTC)
In-Reply-To: <bug-187221-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=187221

--- Comment #1 from Patrick Schaaf <kernelorg@bof.de> ---
Some more info on my problematic machine / further diagnosing is in
https://bugzilla.kernel.org/show_bug.cgi?id=187231

Summary: at least with the P440ar controllers, such 10-30 second "logical
reset" episodes eventually reveal an underlying faulty drive, and go away when
that is drive is replaced.

But there is no up-front information in the "logical reset" that would permit
pinpointing the drive on the first round.

-- 
You are receiving this mail because:
You are the assignee for the bug.
