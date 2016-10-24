From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 176951] boot fails unless acpi=off Acer Travelmate X-349
Date: Mon, 24 Oct 2016 23:55:59 +0000
Message-ID: <bug-176951-11613-rkQPlGs4DA@https.bugzilla.kernel.org/>
References: <bug-176951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754157AbcJXX4G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Oct 2016 19:56:06 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 90FA62026C
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2016 23:56:04 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id BDFDB20260
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2016 23:55:59 +0000 (UTC)
In-Reply-To: <bug-176951-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=176951

Len Brown <lenb@kernel.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|Config-Tables               |Other
           Assignee|acpi_config-tables@kernel-b |scsi_drivers-other@kernel-b
                   |ugs.osdl.org                |ugs.osdl.org
            Product|ACPI                        |SCSI Drivers

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
