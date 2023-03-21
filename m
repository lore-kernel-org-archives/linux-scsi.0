Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C410CC6FD1D
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Mar 2023 10:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjCUKBD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Mar 2023 06:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjCUKBB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Mar 2023 06:01:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27FA2B29C
        for <linux-scsi@vger.kernel.org>; Tue, 21 Mar 2023 03:00:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6618FB80AAE
        for <linux-scsi@vger.kernel.org>; Tue, 21 Mar 2023 10:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D9F3C433EF
        for <linux-scsi@vger.kernel.org>; Tue, 21 Mar 2023 10:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679392855;
        bh=5OA2rwesfZ5l0jkZztiP4BrfK+cHyRPdX0T8eEkapgw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=YjQO0zjjT6wkKIgbUOgElv0MPFKM0xVKKJtrbsqCxhiaxufnQqG5mCLGZKyR8Dj4E
         7HyVA9uqCq0fAxf5NoOsnNqNtBOn51IMMTmK69WbImvpEDtXzvQy4wQLizbtu/FFK2
         1J6rufD23wpLwmYJr/isUNf/8MoCiLVFeQoECEijQlgqVgcJ09ElmjuXMPE2thCxIb
         EEFvBw1UZn6UPznByrwgOjYK0sMSpHsofKe4veYjwXDfYeFkhPPpzVUYAOxEt5zqyd
         w8c5pM1vm0nAcqJCztR+EBROzj6uRXnoHDbWi9cUdUMFVESxpEHl5/3Xvq1ryynWSZ
         Jgk5xm2T6rogw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 07360C43141; Tue, 21 Mar 2023 10:00:55 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 211903] scsi ses driver null pointer supervisor mode access
 prevention
Date:   Tue, 21 Mar 2023 10:00:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: janpieter.sollie@edpnet.be
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: UNREPRODUCIBLE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-211903-11613-Cxg61k2H1U@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211903-11613@https.bugzilla.kernel.org/>
References: <bug-211903-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211903

Janpieter Sollie (janpieter.sollie@edpnet.be) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |UNREPRODUCIBLE

--- Comment #1 from Janpieter Sollie (janpieter.sollie@edpnet.be) ---
bug no longer appears

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
