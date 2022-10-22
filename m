Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A23C4C04A95
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Oct 2022 03:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiJVDlx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Oct 2022 23:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiJVDlv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2022 23:41:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B67D275DC2
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2022 20:41:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73DB860EF3
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 03:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B924EC433D6
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 03:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666410108;
        bh=jOxi8ml6b1YBDDlr157DJKRWVefOVlcP1iskyuSno5o=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=bEwwnsfqvOJ5rVTQTXilK/6XZYXZXbLtQ4xIqds2eFYfl5udDDra2jiRLrBXjzNcA
         u26kIiHHGZZSoavawHEWw70K5sN5EyZad/ZY8bPpmdCyEIEJNgrFAtaF0ll3Rnr5pn
         9RO2SBJlsNn/D8uY8i/sMJYsEftmAdeXFVNVx3CDpHkBT0P4nfPuWQzwKkCiTFvem7
         g5dGh/OesOJH3cVhQ5WFFN2b3rc5W/Df6uxRNafoa89nOpIbcPTQGsGs04E1aqw3sg
         lzKeck7seguDKQRZBouaIK1GNfLKnCqdpoz2Gr8wDlFwGBZXeAOlglRol3wIlMpvzp
         BFrogHJgEMjhg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A593BC433E7; Sat, 22 Oct 2022 03:41:48 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216588] RTL9210(B) falsely detected as rotational disk
Date:   Sat, 22 Oct 2022 03:41:48 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mkp@mkp.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: drivers_usb@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216588-11613-ZFmonfB7kX@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216588-11613@https.bugzilla.kernel.org/>
References: <bug-216588-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216588

Martin K. Petersen (mkp@mkp.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mkp@mkp.net

--- Comment #3 from Martin K. Petersen (mkp@mkp.net) ---
I propose you create a udev rule to override what the device firmware
erroneously reports.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.=
