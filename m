Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D5CCDB474
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Oct 2023 11:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376969AbjJTLIY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Oct 2023 07:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376945AbjJTLIX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Oct 2023 07:08:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B790E8
        for <linux-scsi@vger.kernel.org>; Fri, 20 Oct 2023 04:08:22 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AC16DC433CA
        for <linux-scsi@vger.kernel.org>; Fri, 20 Oct 2023 11:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697800101;
        bh=4Ao+PmbQb9AXgIhqE1vfa3bttVaU+v0vDZriJwoLv+c=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GFRae7YN3W/QptWjVY1QhA2zdA2W6RYbAypNArkcwtX8uZi9GT3EAhIJpB+RinwWh
         Xei3bap1iPt9+s40cNDFJfaCbdPk3SdsvSxqhUd0ih3FMyjj3gK+HQYESyEjALnWQI
         F6qsc3k/JOfoBX4015I5x4rvs75/kJyta+Vu0CfDYH54neSROCoB/IwSoT6G6eDPoi
         wViyD3mYLC7Acru0HQ+cR/jqcxkX3ciwPxpoYvieK5wN57Pd6OSNbmxTVa7CPhNi0j
         lXCA8/93u/3/cBuvU42HbEy4SAZvST1Gt7ufFPcVk3/rc6Tn2VUmi9Ie+s2wyYZIJF
         oJvxkwnbgeOnA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 8B489C53BD0; Fri, 20 Oct 2023 11:08:21 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Fri, 20 Oct 2023 11:08:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: regressions@leemhuis.info
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-5ZnfcXg4Zr@https.bugzilla.kernel.org/>
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

The Linux kernel's regression tracker (Thorsten Leemhuis) (regressions@leem=
huis.info) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |regressions@leemhuis.info

--- Comment #21 from The Linux kernel's regression tracker (Thorsten Leemhu=
is) (regressions@leemhuis.info) ---
Sagar Biradar, what's the status here? Is there a patch in sight? Or would =
it
be best to revert 9dc704dcc09e for now?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
