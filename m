Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AACD0C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Dec 2021 21:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240890AbhLQVA5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Dec 2021 16:00:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43314 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237096AbhLQVA4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Dec 2021 16:00:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A21C2623C0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Dec 2021 21:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 183F3C36AE2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Dec 2021 21:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639774856;
        bh=jfpvEfNkqE/2sP9WFNTzvV8qkDiTjp0lAXwUqTme4PQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=cEGEZ7rIdbYw27H+GIy3JYM4XB4AGu4CxBKNDOCl+CCkaFFHktyRjhwwt6HRisWrZ
         b7GtfRpKYGEI+FwjfTPgqDn6YVilFYJmx0KO/4uetpdJ5xrIZbW9TUwxKbKPEH99uJ
         EJCKsfIl8xoBtP5/aw49XYxwxEbS5n/FSoqqi3rMaBerI0ongLx6HZeDUX5svvX35W
         3GyNeUGKpMurMCSof+KiWMf7vm4rU0uwveVVLTBU6TsiUeqAMSIpdBGexhGUCOpIy8
         9xdChh3Yl/5SmegV3FYAgbNYUFWF1DWDn+HlnOwpndWfKZ7/kKPOu3++qV3RNAXZDJ
         nr6AvzgqGwK9A==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id E44FE60E8B; Fri, 17 Dec 2021 21:00:55 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215353] VMWare LVM partitions not recognized, sees base disk,
 fails to Boot
Date:   Fri, 17 Dec 2021 21:00:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-dc395x@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: richr410@yahoo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-dc395x@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: component
Message-ID: <bug-215353-11613-pV3k7atUg3@https.bugzilla.kernel.org/>
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
          Component|DC395X                      |Other

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
