Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD81C001DF
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Oct 2023 12:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbjJVMoi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Oct 2023 08:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjJVMoh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Oct 2023 08:44:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB295E9
        for <linux-scsi@vger.kernel.org>; Sun, 22 Oct 2023 05:44:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87E82C433C8
        for <linux-scsi@vger.kernel.org>; Sun, 22 Oct 2023 12:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697978675;
        bh=nurvKbK59nQKaYS59JWtDs9H/FuUcbVe6zNYDKU3jLs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=AfIeNdPGyleb3nzKIxr5nkv4vCV34EO+7xYDKZnSXkwbdBrwKSz/0aINcv981sbky
         Fg/mO0kfcm20kus8sMgnFgeuwVPpmi/AC0wLpm/yBHzw37DktSxgaxWsYdXtzG04q+
         UHBnKy79AiSkAQPwRmPnldpQco4rs6kXm+G2zUKUHXnDQJamKW8Ac8x3+6z9J4kgwA
         hvl1VHG7b8S4ngl8bWMMRYkqPTa8K/skVZOkBb/kVcIlxGKMaBHLne+rxxeBZKBO8R
         wttT2iT0VTysSiUsvYTvwT53lDIN2ovb4J2io+EX4o2ZAXOuFHmkgh7cV8f3hdhpfU
         zc1csipv6o2QA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 75FFDC53BC6; Sun, 22 Oct 2023 12:44:35 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 218030] Marvell 88SE6320 SAS controller (mvsas) cannot survive
 ACPI S3 or ACPI S4
Date:   Sun, 22 Oct 2023 12:44:35 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nickosbarkas@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: rep_platform
Message-ID: <bug-218030-11613-FOtFZrxRGu@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218030-11613@https.bugzilla.kernel.org/>
References: <bug-218030-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D218030

Nikolaos Barkas (nickosbarkas@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Hardware|i386                        |All

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
