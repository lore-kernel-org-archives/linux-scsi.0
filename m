Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AADE5C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 01:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240801AbiKRBB0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 20:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240767AbiKRBBY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 20:01:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2145A84324
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 17:01:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEBE8622CD
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 01:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E541C433D7
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 01:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668733283;
        bh=vdpq3b+0K4B7ycrkojK3z33ENIjcNLrkbDR0oJBQQjs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=EH1G2yIXfYTpgXE/AxphuMXvLpDNDLJI7Hn5gX2CFDWHanNPGhLaA0k4ikNWUh1lz
         rgc1f2BPX8MskNqh7Lg/UEHyBF7F8JVI0Pio/hCzDS73YkrFk5mYIau7S+SsFqPqOQ
         VXwad1946jg7/qG1M9genDzSfykWgpfUlLHkyQUyFkF6r6lK99Hqx6EyFDXx5WYXaC
         5+zPEaumntR8UIkHXI2ooqnwQ4Re65XBmKqaeRYDzi1dbIYBDrTfnB5sIBdEGCtLsf
         ra0FwIdj517IUg5XAmcd7xdUIjlqRIngyg1JHJtX+iNeixVrU2OpnsrGuqK+9IdRu7
         wCI8OSNM/emCA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0F656C433E4; Fri, 18 Nov 2022 01:01:23 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216696] Linux unusable upon plugging encrypted SanDisk Extreme
 55AE USB 3.0 SSD, causes xHCI controller crash and drops USB keyboard/mouse
Date:   Fri, 18 Nov 2022 01:01:22 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: kylek389@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216696-11613-OkrSqGVNyu@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216696-11613@https.bugzilla.kernel.org/>
References: <bug-216696-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216696

--- Comment #4 from Kamil Kaminski (kylek389@gmail.com) ---
At the moment I'm on my other system with B550 chipset and Ryzen 5800X and =
have
2TB SanDisk Extreme 55AE plugged into that, however this system was also
exhibiting same exact problem as original (B450 motherboard with Ryzen 5600=
X),
so I can give you a dmesg from current B550 system (see attachment), and yes
other USB devices or working fine now (I have an USB SD card reader plugged=
 in
and Oculus CV1 and they're working fine)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
