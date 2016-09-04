From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151661] Adaptec 3405 3805 prints "AAC: Host adapter dead -1"
 every 10 seconds but works fine anyway
Date: Sun, 04 Sep 2016 11:25:02 +0000
Message-ID: <bug-151661-11613-mrkun4V2wh@https.bugzilla.kernel.org/>
References: <bug-151661-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750729AbcIDLZG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 4 Sep 2016 07:25:06 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 99564203B8
        for <linux-scsi@vger.kernel.org>; Sun,  4 Sep 2016 11:25:04 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 8FD2320380
        for <linux-scsi@vger.kernel.org>; Sun,  4 Sep 2016 11:25:02 +0000 (UTC)
In-Reply-To: <bug-151661-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151661

--- Comment #12 from a@borouhin.com ---
The same problem for me.

Ubuntu LTS 16.04.

# uname -a
Linux trinity 4.4.0-36-generic #55-Ubuntu SMP Thu Aug 11 18:01:55 UTC 2016
x86_64 x86_64 x86_64 GNU/Linux

# arcconf getconfig 1
Controllers found: 1
----------------------------------------------------------------------
Controller information
----------------------------------------------------------------------
   Controller Status                        : Optimal
   Channel description                      : SAS/SATA
   Controller Model                         : Adaptec 3805
   Controller Serial Number                 : 8C211053127
<...>
   --------------------------------------------------------
   Controller Version Information
   --------------------------------------------------------
   BIOS                                     : 5.2-0 (17342)
   Firmware                                 : 5.2-0 (17342)
   Driver                                   : 1.2-1 (41010)
   Boot Flash                               : 5.2-0 (17342)

$ w
 14:24:22 up 20:41 <...>

$ journalctl -b | grep 'AAC: Host adapter dead -1' | wc -l
7284

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
