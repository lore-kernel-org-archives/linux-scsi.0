Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07BEDC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jan 2022 20:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbiAUUKk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jan 2022 15:10:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36382 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiAUUKk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jan 2022 15:10:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE0A261757
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jan 2022 20:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4E74EC340E8
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jan 2022 20:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642795839;
        bh=nHy+bVOuFLQO49OYaN0E55fV0ZV8pMi7IIxedSJfH9M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fJ3Y6oY4km0zhdLfjG2r1R2J53hqujs6/1Dej0vhsTrc0z7021B7g87MN+kndcYCD
         btvbnzKxkSkHlAgefMI28d37CiTDoIuaQy14jGKiQONQUnEbk9vcAqE/hQbW0e+YN3
         93yg1ubsewE4mkHSya1AaPFTNcccRjQvXCxFuSJYtaeOiqyFea7l86qgPtyAZ2YQKH
         ol4CnkcQW0I4lsXmTpvIX9m4fqgYr9KYvQiFJH9j6YZLvL7l2ZJYT3VtWswkWZ5hko
         OIkKJO9UC6O9jKPPbnUBPvw5lmWAscDkR0qfwY+2TPGGCcCcdT6Nau4qSZ87Oeoj3n
         ck6XS7ooi05lg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 35081CC13AC; Fri, 21 Jan 2022 20:10:39 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215353] VMWare LVM partitions not recognized, sees base disk,
 fails to Boot
Date:   Fri, 21 Jan 2022 20:10:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-dc395x@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: richr410@yahoo.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-dc395x@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-215353-11613-KgUjSgbPYk@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215353-11613@https.bugzilla.kernel.org/>
References: <bug-215353-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215353

Rich Reamer (richr410@yahoo.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #8 from Rich Reamer (richr410@yahoo.com) ---
@Martin -- yah!! it works!! (testing kernel 5.15.13)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
