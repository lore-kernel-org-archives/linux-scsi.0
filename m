Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF673CD4F32
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 08:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbjIVIdC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 04:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjIVIdB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 04:33:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34D48F
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2023 01:32:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F56AC433CA
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2023 08:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695371575;
        bh=LnrmFmEuXTGrOTQruF5GyfoEHzVGzfPhTPTDt2nLfDQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ld4BtXGfLkaYjSk0Z9iTUj/nndlMmDku7WZTmeGo8ffwe/XR00ZpMzAon++kKLfEn
         O7V9i7n1M6ckDDsp6OH3tdIH4X4g2A3ggB+qSIsgoHIP2JlEyDBLkyQsr3fHk0xed2
         xm4uGFm1H+cPBry4MK9+HfGLSpVOhk0IjNWqBO2NBhLnKfwvG0eJYpRmaIigFV/Wwv
         IkUfASJZFVyHN5EW6UreJSBG9YLhuaUxXHJSni5S0IyEPaFBytrghY2rYrci4VRoQV
         URg/UfY0ZLq1VhBNPDont67aSAivCoLuE7nY04Ufb5JPqX4VDuciQ2U5dizzxZr8bd
         c7+FoVMZ8wCUA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7A544C53BD4; Fri, 22 Sep 2023 08:32:55 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Fri, 22 Sep 2023 08:32:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: juhani.heinonen@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215788-11613-6MD7wiP0Dh@https.bugzilla.kernel.org/>
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

Juhani Heinonen (juhani.heinonen@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |juhani.heinonen@gmail.com

--- Comment #19 from Juhani Heinonen (juhani.heinonen@gmail.com) ---
I just upgraded my kernel from 5.15 to 6.1.53 and this "executing hw bus re=
set"
popped up after a few years of smooth sailing. I have Areva 1880ix-24 with
firmware V1.56 2019-07-30 and arcmsr driver version v1.50.00.05-20210429. I=
 am
just reporting that mysteriously this error appeared after quite a while.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
