Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60169C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Nov 2023 09:37:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbjKHJh0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Nov 2023 04:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234965AbjKHJh0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2023 04:37:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104C51A2
        for <linux-scsi@vger.kernel.org>; Wed,  8 Nov 2023 01:37:24 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7071C433C8
        for <linux-scsi@vger.kernel.org>; Wed,  8 Nov 2023 09:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699436243;
        bh=AQ1idZrgMZUKp4ddSR36LKVnpwo+ec+AQijQVJcoP7Y=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=UKyM65E0W0hymYlQd9rVdxkkbchWR82RH542D3bfFSLKX8CMq2kriZbb0P4ZiGuJw
         PPv5eWmhumJOlgo0Pr5LnWq7/Hozlj58uL/h5Gl3pZQIKG9MWTufOgJe5KXrnDROUd
         BJEhTntkMJDfUA11yQsRH2Yy+s41uWqUmUGbOf7OiIrSEWFBgR3s6/nGBIHjUou9GO
         wbpEfuQ1GIL9vioXnX7P9chQXklWjfpuPsvj2bLJzOByFINKN1ju3KxvMx7z2oJIX1
         sydSwgjPQs3MeudUTtheCPnQ0l9P7s67sgpv3TlqHtSqQsS/gVhenkRNKA9CVM8QIk
         aAewlQUuR2eGw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 92EDFC53BCD; Wed,  8 Nov 2023 09:37:23 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 198923] Linux 4.15.4+: Write on Ext4 causes system block
Date:   Wed, 08 Nov 2023 09:37:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: murphyde835@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-198923-11613-LbG11Qg34v@https.bugzilla.kernel.org/>
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

Javier Crosby (murphyde835@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |murphyde835@gmail.com

--- Comment #11 from Javier Crosby (murphyde835@gmail.com) ---
I'm encountering comparative issues as of late when rhythmbox(a case catche=
r)
is attempting to compose a downloaded mp3 record to a ntfs volume. Framework
isn't completely hindered however, just all further access endeavors (sourc=
e:
https://coreball.co) to that ntfs volume fall flat during that meeting and =
upon
closure, the framework hangs tight for Circle Director for over 10 minutes
(didn't stand by significantly longer and did a hard reset).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
