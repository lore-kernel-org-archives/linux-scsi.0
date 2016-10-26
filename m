From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121531] Adaptec 7805H SAS HBA (pm80xx): hangs when writing
 >80MB at once
Date: Wed, 26 Oct 2016 12:52:30 +0000
Message-ID: <bug-121531-11613-9GW0jSg793@https.bugzilla.kernel.org/>
References: <bug-121531-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942107AbcJZMwg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Oct 2016 08:52:36 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 8CAD82021B
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2016 12:52:33 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 8D08C20221
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2016 12:52:30 +0000 (UTC)
In-Reply-To: <bug-121531-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=121531

Chloé Desoutter <chloe@tigres-rouges.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Attachment #242701|0                           |1
        is obsolete|                            |

--- Comment #21 from Chloé Desoutter <chloe@tigres-rouges.net> ---
Created attachment 242801
  --> https://bugzilla.kernel.org/attachment.cgi?id=242801&action=edit
pm8001_defs.h patch [2]

Set PM8001_MPI_QUEUE to 256, as in the MicroSemi driver.

-- 
You are receiving this mail because:
You are the assignee for the bug.