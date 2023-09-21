Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA496E7D0AD
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 21:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbjIUVhh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 17:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbjIUVhY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 17:37:24 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD53D527F
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 14:13:22 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12337C433C8
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 21:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695330802;
        bh=+U9hcCnu59J1LgaG9sM42KIckRVPEEfa+aw1k2B9vjs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=shAYz+M4Oeru9+OntaVGMHXYXl4aJau/Opu/pzOA1A8+XUz/IojppNCM0mCu6jMGx
         r1G/wrO0JZ4Jm7znyeIz5vjN/5Q2TY332+KgOBV4rZZfwnsDce7RdHHFmTts+CsY/M
         M9AVxUW6cTuMOO6CkRTK4fSFL9GC9t7W0B3aQPpf2RtSxDb7qOOSlPhyLdDhdlOXkn
         IFAJkuCfdsKRo0pMpgKcLtUa5EZuLIIFyc6J61kZrS6tVmC0K6Fu8TQRRnn/V38UlS
         sboZIfcy6vo/RipVtkGgW4QHr/y/Mop4gDBKR4TMsV/tOzc9gcirambZ8ChmCNtGfA
         4zT1k5sQFljSg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id EC0EDC53BD1; Thu, 21 Sep 2023 21:13:21 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Thu, 21 Sep 2023 21:13:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: iissmart@numberzero.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215788-11613-vlcy9MvcIW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215788-11613@https.bugzilla.kernel.org/>
References: <bug-215788-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215788

Ken Link (iissmart@numberzero.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |iissmart@numberzero.org

--- Comment #18 from Ken Link (iissmart@numberzero.org) ---
I am also experiencing this, on an Areca 1882ix-24 with firmware V1.56
2021-01-12 and arcmsr driver version v1.50.0X.14-20230614 in Ubuntu 22.04 on
kernel 6.2.0. I take it the 5.18/discovery branch hasn't been merged anywhe=
re
yet? What more testing needs to be done? How can I help?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
