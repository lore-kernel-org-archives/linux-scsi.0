Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B67C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Apr 2022 05:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiDEFKk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 01:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiDEFKd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 01:10:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE88E6457
        for <linux-scsi@vger.kernel.org>; Mon,  4 Apr 2022 22:08:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5833261365
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 05:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD110C34111
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 05:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649135304;
        bh=6Xd+KNZ8T2tbEB16K+KJQx+P+XxUaABaVXyLoy/y2ZU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=UeGJLIutqIjcHDT7zQom/0zHXCrBFCrEXhn4C0H1tZXGD4+LDdBkGMe9Pg3OQQtIJ
         oHPRN+EcFqjAtd6Zu7Pb6QAVrXye+brVN4KrYaBmuLGF9VOdWqgWr+tGzRf9HIxzq6
         tGVpDpRa697BDbEVRPFBQgHR3U0kWyqH4/JMGLD8A5tqw1yT5KOxfgqKZSycjmnrG1
         95rZGTGnM9Win9PpfTqeZ/O4EUlJg0Z4dhXFgugAridBDRVPIXmuBOck5xfeOEWcFX
         t9iUnJo2LiT7yCsKUcvjogJGusNWNOhjuBbfaRlQXPE1FWGBssqISS4f+06rPfWGTX
         KSHQkz5UyJ13A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A32FDC05FCE; Tue,  5 Apr 2022 05:08:24 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Tue, 05 Apr 2022 05:08:24 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bvanassche@acm.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215788-11613-atTqiTG3Mw@https.bugzilla.kernel.org/>
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

Bart Van Assche (bvanassche@acm.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bvanassche@acm.org

--- Comment #2 from Bart Van Assche (bvanassche@acm.org) ---
Would it be possible to bisect this issue?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
