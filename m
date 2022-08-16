Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322D2C3F6B0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Aug 2022 16:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbiHPQOb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Aug 2022 12:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbiHPQO0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2022 12:14:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE135005D
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 09:14:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 168D261213
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 16:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B0C6C4314B
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 16:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660666464;
        bh=zMiAR9KnKcUHtVyFdJ2p9u1uOSmWvBsfqKJ40C3CpR0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=F7GV3HaDFyqvIOHB4o40mLcjOLDQFDuKBJMZsHOi/BiBwlcs5Ek1sWhoOROgTjdp/
         WaVXtBBMgLu0i4kDnpAqrsbDB+jHdbBC3uN3dPaZTFWgj2hd8uwAnh4Tz+9uPngnN1
         9i1I1cd8k/JX+m+EdAJhDY5RsylJHUSrshPTBWp8hayPSuVt7Oymxr5LFuVSmtpt9I
         z55FisXpx+0dAB6FK/Nyas3j2uMz3cjiKFoIBBHPeMbFT5IZoaQAccIYbOMi5mspW0
         RXUNGOreX+5nRDThsWrpwrb+YhPKY2sLNhUeYtFM0/jLSKZrO5OscMixy7H2tXkQDy
         NtOrJHhvGoKSw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5B07BC433E9; Tue, 16 Aug 2022 16:14:24 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Tue, 16 Aug 2022 16:14:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: damien.lemoal@wdc.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215880-11613-UAnqZSmQAp@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215880-11613@https.bugzilla.kernel.org/>
References: <bug-215880-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215880

--- Comment #34 from Damien Le Moal (damien.lemoal@wdc.com) ---
(In reply to Nils from comment #33)
> (In reply to Bart Van Assche from comment #30)
> > I think that commit 88f1669019bd ("scsi: sd: Rework asynchronous resume
> > support") got merged in Linus' tree (kernel v6.0-rc1) about two days ag=
o.
>=20
> Great, thanks.  Looking forward to testing it once my distributor ships i=
t.

The patch has a fixes tag, so it will get backported to the latest 5.19 sta=
ble
too.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
