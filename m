Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FEC3C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 21:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiASVUw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jan 2022 16:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiASVUs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jan 2022 16:20:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047B2C061574
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 13:20:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 979786119C
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 21:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0AD22C340E4
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 21:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642627247;
        bh=1GZYFSqAczPtakEXavWyFoXR9Qhea2opC3dPnVpkDAI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=g1Wq8/DccX7SdLBOKaiL87Djs1MuMMJp+v9K5N73skKHWP7+sZ1y5W3RW88E07m2M
         Z0QX9nv+Cak1JJY1taBS4dsbJ4IqHURIhm1g7bQWqDdVzEL6ASiVI3+M0SCimTOgBC
         nDq+OPlsPBK1+95FwkcVQPvFIdZQZri4dRPFD/r/9Yf7ihQs1LYpAVf4TraBsXSOwo
         B7RbPtAottnNviabdPsIm0YL+/d73aO6Uh3F8UetCCaLIR/Q+fVOxBD93rYzYK4w04
         QUO0zHTUeDUxx4bPp6AqIOB/DUCgBzgPaXA25S+um0HUxcX09vt0CYAm7ZfmZcAOcg
         HCljbE+HWKU/g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E677ACC13AF; Wed, 19 Jan 2022 21:20:46 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215447] sr_mod scsi_mode_sense() failure -> "scsi-1 drive"
Date:   Wed, 19 Jan 2022 21:20:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: cshorler@googlemail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215447-11613-u7cLJZemWA@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215447-11613@https.bugzilla.kernel.org/>
References: <bug-215447-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215447

--- Comment #9 from Chris Horler (cshorler@googlemail.com) ---
okay, thanks for the update!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
