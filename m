Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087DBC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Apr 2022 01:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442997AbiDVBFD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 21:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239067AbiDVBFC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 21:05:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE4D483B3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 18:02:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD361B829DA
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 01:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8AB52C385A8
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 01:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650589328;
        bh=EtrU2kYumYXc5jL5OwUzH7vYKC1f6S12VpeUPw/FH/Q=;
        h=From:To:Subject:Date:From;
        b=fLEqFUB0P2SCB5Yao0s3VYJ6pPIxMHNq55TpOKn5U4kcDZQyfmFHo8I8k0yf30P5w
         kbmVSaDPVAn1d0Fh7emPBiHTHbiTnW8u6qfVHkymiN9OUfrYgOOpWu2s0qLEt7xFVc
         Q4df92qml+NtZwRzT0L/bw0QXVzUHWrogeL2wZCeW4i1Eo6hhiGXZc3KGx4DUlfTOv
         7WEK6z1mJnMUitvPVpuvfX3OMQ45arwlfH2upooKgEGrFbzIszjR5dUdKK0rPU4D6d
         F2vdjNmzrpUu26GGtgWjhq/Bk0bnaQmpNyJMkHkOK9OwW3SEVeCmGgOKTSpQssSJGb
         zwIt0T5Wulcug==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 687EAC05FD5; Fri, 22 Apr 2022 01:02:08 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215874] New: The wifi driver is not there. Not even the network
 driver.
Date:   Fri, 22 Apr 2022 01:02:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: priyatoshpaul@yahoo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-215874-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215874

            Bug ID: 215874
           Summary: The wifi driver is not there. Not even the network
                    driver.
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 5.10.112
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: priyatoshpaul@yahoo.com
        Regression: No

The wifi driver is not there. Not even the network driver.

After compiling kernel on the ubuntu 20.04 lts.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
