Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A171DC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Oct 2022 23:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiJUXB4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Oct 2022 19:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiJUXBx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2022 19:01:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3008297F32
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2022 16:01:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37B9561FA3
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2022 23:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94C7FC433B5
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2022 23:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666393307;
        bh=gjL2+7KpMk+0JM03uakJYSo6J79vzF/mgN2CZ3kmwr0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Pf1tB1Qoen3+3p7Zs9OLb6eXKTN8w1vym+BskdCunTQxRkk3erRycdMqHcUsVzCfg
         NEftQqh7v0PdH2+3fD+7SJBZcDQmMh2r9yDYlxmaDP6GEhnkcmBINQZg1n1VnjnEwH
         IbvAT7+xmcXWjfKd48nbgU2e2xeYRbBMRHWmIxdWTkPxFrBoFC1liXEl2gZvmiN0aY
         rzOpU0CIiFDmPM87DWcHjilCR+Zgx+b3z25gWmTQyX5F9B9rYy6kB24CHO8HhzQH4A
         m22Iw1u2jMqSXQhd7gI9wcQ5+XuDma1/UYIRjqcC0T2mLBgqeN0DebVqIAZzUm/WE+
         QOsyYS/PccSyQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 788D8C433E6; Fri, 21 Oct 2022 23:01:47 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216588] RTL9210(B) falsely detected as rotational disk
Date:   Fri, 21 Oct 2022 23:01:47 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: supgesu@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: drivers_usb@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216588-11613-2LPmhrFG5U@https.bugzilla.kernel.org/>
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

Elias (supgesu@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |linux-scsi@vger.kernel.org

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.=
