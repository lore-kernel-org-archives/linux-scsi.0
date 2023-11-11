Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3024DC4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Nov 2023 00:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjKKAzT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Nov 2023 19:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjKKAzS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Nov 2023 19:55:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C0244BF
        for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2023 16:55:15 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32307C433C9
        for <linux-scsi@vger.kernel.org>; Sat, 11 Nov 2023 00:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699664114;
        bh=twUuQOMV5LrqDUc8iFfpijN8lbe+U41Jy48Fn/p+dis=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=TVQZSztcRQEFHajzrNB5TRRC2xil78lFLJf8di+EJboWel5XX1+DIVz84V9suQIcV
         js5i+WUUoCm/RHzanxGBN14390KQcpepy1EJdbH4uo/TAIwOwoyXbOT+EqCXH+e1DE
         wKKEKCwWHJ7tETx0H7tvfcDZ/ub5hZtLm702kDI3K0YcGxOPJdvR9P9roXQgm4d2hT
         42gMbZ3ZdIePSxH5Ubeuz+rDUe/Rr8q8oyuS39CLSj+7P9p4Ai06hPsGVcybalZePx
         UJXQ76rIwTn/+Xa3NcKrTox+ncOqyHp7NlkEuTHk3B1jWnvuDHcuT1IlC8+2rriHqN
         2A3CXipHZ/sCA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 16933C53BD2; Sat, 11 Nov 2023 00:55:14 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 198923] Linux 4.15.4+: Write on Ext4 causes system block
Date:   Sat, 11 Nov 2023 00:55:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: tytso@mit.edu
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-198923-11613-X8NUfRPq2m@https.bugzilla.kernel.org/>
In-Reply-To: <bug-198923-11613@https.bugzilla.kernel.org/>
References: <bug-198923-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D198923

--- Comment #12 from Theodore Tso (tytso@mit.edu) ---
On Wed, Nov 08, 2023 at 09:37:23AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D198923
>=20
> Javier Crosby (murphyde835@gmail.com) changed:
>=20
>            What    |Removed                     |Added
> -------------------------------------------------------------------------=
---
>                  CC|                            |murphyde835@gmail.com
>=20
> --- Comment #11 from Javier Crosby (murphyde835@gmail.com) ---
> I'm encountering comparative issues as of late when rhythmbox(a case catc=
her)
> is attempting to compose a downloaded mp3 record to a ntfs volume. Framew=
ork
> isn't completely hindered however, just all further access endeavors (sou=
rce:
> https://coreball.co) to that ntfs volume fall flat during that meeting and
> upon
> closure, the framework hangs tight for Circle Director for over 10 minutes
> (didn't stand by significantly longer and did a hard reset).
>

I suspect you commented on the wrong bug...

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
