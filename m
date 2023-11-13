Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C56AC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Nov 2023 12:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjKMMCI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 07:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjKMMCH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 07:02:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3B5D72
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 04:02:04 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD6A2C433C7
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 12:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699876923;
        bh=G5jj5BfcT2xo1rNT1BduTYoJsLFRwE2+72tRiCA2k98=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GTAo2amaKqVSB2H6dqcAXRz8YsX1xgTRXfxitInaHpFALe4FIh4ot9GnTPQEFCekf
         d7PXCfElRJCGEPA3DhDj/eSkilbawkXRfmjbdIevLMkLATfjM77WkZR0GPhuSfveye
         gHK+VsQ90nixfXdc6hxQeAKZkMtEMI4MYtbhqSz0RQAwhpCadg8b/geQz2Tx0m9/J8
         h7KqzXXbOCyf4temKSE7wxNeThd0fLe2wm35XS7hqCoE+61F4BIv+AQCcpd8Z97+j3
         EYHfHYQhDNetMLRha3KzSlxZT92VR4QUMeH7cvSWYrY+5zchrgtd6nCeHSaQXk6MSh
         fiYiGgXVrCK9g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C9117C53BD3; Mon, 13 Nov 2023 12:02:03 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217914] scsi_eh_1 process high cpu after upgrading to 6.5
Date:   Mon, 13 Nov 2023 12:02:03 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: kernel@nerdbynature.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217914-11613-qFN0Af0l6Z@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217914-11613@https.bugzilla.kernel.org/>
References: <bug-217914-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217914

--- Comment #9 from Christian Kujau (kernel@nerdbynature.de) ---
Oh, great! I was only searching for  the subject line, not the actual chang=
es.
So, I just have to wait for Debian (Backports) to move to v6.6 then :-) Tha=
nks!
This Bugzilla entry can be closed then, I assume.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
