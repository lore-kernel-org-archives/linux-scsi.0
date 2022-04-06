Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 164F7C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 10:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbiDFKjF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 06:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354578AbiDFKhh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 06:37:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05779138592
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 23:59:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9151C619A9
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 06:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC521C385A6
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 06:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649228382;
        bh=Orqy6ACBE3X5JdhoudqLKiTUJmgvK1br5cGmi1aIkks=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=gX0fnrr4ngJy1chBJdyTuu/+UDx2VNop0wphT/P1tDUt+sFuLDDqrc0S59YDcF7cq
         qY6xLZ4RQ+MXGQTgwFgfHuXKU5oCbouV+AxvnhavuJD0KmX9lInsWQSSRSSbSM0rqt
         OZnjAjaub4kMIukN20MZm6ulzpVEDMvzxtC9JUaN7WuBzb9KeOaNDYmkuydydohKat
         hyYAiLCwRzG+AmcNeg9rlywnGkz+nFLAqYL0Ax/2pZSKSX3pnDyxGmzVw2EnowEXzq
         zFZNuaGMMC3E6Coj3vLI5mWuq5P50c86A83NRoDJU9H6u6px9lJxsCtYYfclbqweAw
         70TE3KyRY/Nzg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id BA895CAC6E2; Wed,  6 Apr 2022 06:59:41 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Wed, 06 Apr 2022 06:59:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jernej-bugzilla.kernel@ena.si
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215788-11613-Jgj7Msqxn7@https.bugzilla.kernel.org/>
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

--- Comment #6 from Jernej Simon=C4=8Di=C4=8D (jernej-bugzilla.kernel@ena.s=
i) ---
Doesn't help unfortunately.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
