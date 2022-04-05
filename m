Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E6DC43219
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 01:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448629AbiDFBJA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573723AbiDETxh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 15:53:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181F84338D
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 12:51:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE351B81FC4
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 19:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A10DC385A7
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 19:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649188296;
        bh=QvdaGRRYq7zt37mkWiltdpQOIDKkP/kCENCFWa3eAYw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=iY0VReJ50UlepdDhsFM4RebSPhnk0jTpIaLRyiGQUu5FfyzKtauc17oxwZgpbKP27
         4r41Ai/zyW1ZCDOSBnk7evpU7pNHJhVBSw2vJUeeuNIRNnR3lvWlO0MpFeD0QRYVw/
         S6O72TkxxVVS9Snkm6ogEs3fe0NjaZs0oyTLEk4rk7gmK2c7DCrry+Mf6/a0C7FyQL
         YNnhTo6udiVNSuU0i7TEUGW/by/UVLcvKkzMuK7eJIhubo+Qt56GZAfDqbU4Ou6CaM
         etaP4y8j0HPoruQLmMlhhiQQnDsDgrXCA519yT5APSWGK6Xv1qngji4hVGbHoHi346
         P4xSuz2mRiNLg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4709DC05FD2; Tue,  5 Apr 2022 19:51:36 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Tue, 05 Apr 2022 19:51:36 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215788-11613-ccDoKdPEyK@https.bugzilla.kernel.org/>
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

--- Comment #4 from Bart Van Assche (bvanassche@acm.org) ---
Damien, can you take a look?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
