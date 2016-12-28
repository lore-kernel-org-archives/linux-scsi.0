From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Wed, 28 Dec 2016 11:18:06 +0000
Message-ID: <bug-60644-11613-8ZBtRp8ZKM@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751078AbcL1LSM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Dec 2016 06:18:12 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 8F77A2050E
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2016 11:18:10 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 55DE5204E3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2016 11:18:09 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #51 from ojab@ojab.ru ---
(as a side note, does anyone else has an issue [0] with `rmmod mpt3sas`? It's
reproducible with LSI SAS 9217-8i HBA, and I would like to know if other HBAs
are affected)

[0] https://www.spinics.net/lists/linux-scsi/msg100687.html

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
