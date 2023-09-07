Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63903EC8759
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Sep 2023 21:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbjIGVsQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Sep 2023 17:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232467AbjIGVsP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Sep 2023 17:48:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524F61BC1
        for <linux-scsi@vger.kernel.org>; Thu,  7 Sep 2023 14:48:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3C90C433CB
        for <linux-scsi@vger.kernel.org>; Thu,  7 Sep 2023 21:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694123291;
        bh=7W9UfdQVUZFNDp8L0pRdldYv5O/pmHUi38gwRx2TjJ8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=nwUNnElWEGemvMnLhRB8f4Ys8AuWsGG8Mbe9zAID0OZpvb4hEwlJCnR1ShDyjsBw8
         QPcHXUlE8/x+YwZAc/yk0JKyRmpvbhFqgjGAnSzPg0zB33ZMaQv9NDoakViZWGo9Xf
         KMLBuOB3uyRU236k0wiFwfcert39N4bNdIxSb3MWPevU1wQmZjVWB54L12Q8/0p6TF
         Kg+9UcGKRO3IES4O+PPdHqshKU/IUtBGG5dXBylLjcXeD4YIQ9inIB/pJGgZ0ElUz+
         DcMPIbH+7JtltPUSe9FFaPDDHrFVkv+6uhNlthXj2h8T/cFk59tdCICZxvcN062YDh
         t/OBbtSCPWnBA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CF94AC53BD3; Thu,  7 Sep 2023 21:48:11 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Thu, 07 Sep 2023 21:48:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: maokaman@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-4ZWpTPhAX4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

--- Comment #19 from Maokaman (maokaman@gmail.com) ---
Hardware:

# dmidecode | grep -A 3 'Base Board Information'
Base Board Information
        Manufacturer: Supermicro
        Product Name: X11DPi-N
        Version: 2.00

# lscpu | egrep '^Model name:|Socket'
Model name: Intel(R) Xeon(R) Gold 6240R CPU @ 2.40GHz
Socket(s):  2

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
