Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EBD6C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Apr 2022 02:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443679AbiDVDAH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 23:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443642AbiDVC7x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 22:59:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E8E4DF6C
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 19:56:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1C20B828CB
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 02:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98078C385A9
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 02:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650596183;
        bh=jFVILiu+3qAb+R1NTFxbBnr0j3U8E2d2Zegv3SH+MMo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rkRJ/3rEhrSnvbrlZ3FU8mqbpIcjQJA3gVOcYPIp3Gv6jS0PaGAfHUR3PVnm3FHHf
         ClMYZSuRrhF+AphA94oVa5wShEVT61hO8D6QPEQZB568LsREWKFgoeo64x74dXONC9
         hQar57IQ36fjGEoL2gJIcJ5mAKNKfCoUTHuwENcgV7HM0pjB6t1q2ri4AXylFswvJ/
         wmNFcgtoi8t355fhKUkldS+g5x/G5w3J5FXRuZzAmHxYx4UJasWB/WcNIuMvm9vayX
         IUead0+4XRtn6nbx5AwhyAoIFGuwjAqeB4l2995JCYAcXEohoyYBVULZEvknsdd3+L
         se4S1zCqD7C+A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 734ADCC13AD; Fri, 22 Apr 2022 02:56:23 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215874] The wifi driver is not there. Not even the network
 driver.
Date:   Fri, 22 Apr 2022 02:56:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rdunlap@infradead.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215874-11613-wgfmtQah6f@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215874-11613@https.bugzilla.kernel.org/>
References: <bug-215874-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215874

Randy Dunlap (rdunlap@infradead.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |rdunlap@infradead.org

--- Comment #1 from Randy Dunlap (rdunlap@infradead.org) ---
Hi. Lots of info is missing here.
And this should not be in SCSI Drivers either.
I'm not sure if it's a wifi or netdev problem or a build/config issue.

kernel version: 5.10.112 (stable)
What kernel config file are you using? How did you generate it?

What is your hardware configuration?
What wifi driver is missing?  What network driver is missing?

Have you built & installed kernels previously?

thanks.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
