From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 179341] mpt3sas: LSISAS3008 don't see Intel 540s SSD
Date: Fri, 21 Oct 2016 01:13:27 +0000
Message-ID: <bug-179341-11613-AWI3KvF9Wz@https.bugzilla.kernel.org/>
References: <bug-179341-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753248AbcJUBNd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Oct 2016 21:13:33 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 286F9203AE
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2016 01:13:30 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 24A9B203B5
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2016 01:13:28 +0000 (UTC)
In-Reply-To: <bug-179341-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=179341

--- Comment #2 from Badalyan Vyacheslav <v.badalyan@open-bs.ru> ---
        Adapter Selected is a Avago SAS: SAS3008(C0)

Num   Ctlr            FW Ver        NVDATA        x86-BIOS         PCI Addr
----------------------------------------------------------------------------

0  SAS3008(C0)  13.00.00.00    0b.02.00.03    08.31.00.00     00:0a:00:00
1  SAS3008(C0)  13.00.00.00    0b.02.00.03    08.31.00.00     00:08:00:00

-- 
You are receiving this mail because:
You are watching someone on the CC list of the bug.
