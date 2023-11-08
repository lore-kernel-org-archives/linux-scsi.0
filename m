Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C04E7C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Nov 2023 09:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbjKHJmy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Nov 2023 04:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbjKHJmx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2023 04:42:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEB6199
        for <linux-scsi@vger.kernel.org>; Wed,  8 Nov 2023 01:42:51 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10181C433CA
        for <linux-scsi@vger.kernel.org>; Wed,  8 Nov 2023 09:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699436571;
        bh=lnww/OUZZVq9tGqYzIlKjIU1vjXYFfdQKK7ZCerHieI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=E2rNQXhUap1cFxJXAcCbBXUedM+Vz4eK54UZdyZD9/vl0wIXALNP3+6TyOtEHExLG
         q/aFTv7z3aD1/YkOg5LcJzmdaEPYmP/Cu66DRENXgBnr0xuwFm+ZR8YWR0kJuaF7Dd
         1X5CXINl01b+zcFDl9ASpcTXSmQs2T4uxL/JTPx9PsdjmMy4e3mPXnO0c55HBrlPLn
         Jx7PM581/9fW+6Q2gzM6WlSGoK53BdBQ4xu3qFn4kyobS9az9KHBos0JcU0DxTcPvx
         4No4Awlcd4TXqWS7piVJObO3BrR/VgsI3cnHiXu7mi5dYveTaiRF23uHd/+orws370
         JdO3iny0bTCDA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 02F77C53BCD; Wed,  8 Nov 2023 09:42:51 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 85101] hpsa + P410 does not show connected HP SAS port
 expanders
Date:   Wed, 08 Nov 2023 09:42:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: murphyde835@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DOCUMENTED
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-85101-11613-0Icm3CHKa8@https.bugzilla.kernel.org/>
In-Reply-To: <bug-85101-11613@https.bugzilla.kernel.org/>
References: <bug-85101-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D85101

Javier Crosby (murphyde835@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |murphyde835@gmail.com

--- Comment #10 from Javier Crosby (murphyde835@gmail.com) ---
Regulator lockup implies the firmware crashed (for example a Declare
proclamation set off). That can be because of equipment issues or firmware =
bugs
(source: https://freegamesonline.io). You could check whether it boots with
nothing connected; then, at that point, with one expander; then, at that po=
int,
with two; then, at that point, with drives joined to the expanders.

On the off chance that you're not actually utilizing the P410, however, sim=
ply
use sg_write_buffer through the Adaptec 7805H HBA.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
