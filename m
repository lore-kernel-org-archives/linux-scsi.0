Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48EC1C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Mar 2022 13:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346031AbiC3NqR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Mar 2022 09:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346264AbiC3Npg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Mar 2022 09:45:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB9F52B1E
        for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2022 06:43:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A921612E6
        for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2022 13:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0154FC3410F
        for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2022 13:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648647830;
        bh=FU4pfazs9cQrVTgwl52SymCwjwoSUkLRGiTD0JVkUL0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Fh26laR2leqTqUdPGopIMNPOSXVBQpZHU/qtplZ93dL9HiwI4Y6NFIs4kYWSHRfT6
         iivvikXM/3Ylwbw6SUb8gx2kw6lAjSHIJzNK5fDIk6lwMBjdx5fi66by9pwkE9e7Ja
         hZK0zNdgj/8uLOHmEVaKex9UoDIfEJFhO3QlKnhHHbDF8PSn96Q/0AGJTA20l0kQKf
         Twltt4ola8z00Ih4KlJDK073TuOKkeVNAQzKXak3qTwf9hXyYO3QIqKJxS2DtenDnp
         g7eV16fniRrcMyLuHkXXj2ozDP89plRAxm/u73PAFF41PVXHuTy6bWstfNix4SYE8/
         1uZAwAXhkLALA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D3137C05FD0; Wed, 30 Mar 2022 13:43:49 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215691] mpt3sas "SMP command sent to the expander has timed
 out" cause halt
Date:   Wed, 30 Mar 2022 13:43:49 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: regressions@leemhuis.info
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215691-11613-k6yafjQFRs@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215691-11613@https.bugzilla.kernel.org/>
References: <bug-215691-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215691

The Linux kernel's regression tracker (Thorsten Leemhuis) (regressions@leem=
huis.info) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |regressions@leemhuis.info

--- Comment #6 from The Linux kernel's regression tracker (Thorsten Leemhui=
s) (regressions@leemhuis.info) ---
(In reply to Badalian Slava from comment #4)
> Added another crashs added. Last try on 5.16.16. Rollback to 5.15.4 - few
> days work ok

To understand this properly a quick question from a bystander: the problem =
you
report is new in 5.16.y and 5.15.y work fine?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
