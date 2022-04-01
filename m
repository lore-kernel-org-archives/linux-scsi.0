Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20032C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 11:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345298AbiDALDB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 07:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345284AbiDALCo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 07:02:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A2926F201
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 04:00:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B5F0B82471
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 11:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12A70C3410F
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 11:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648810853;
        bh=R97vrJI532hibRzIQZsov/K2Q4guRydaOGgC5+bj65w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jBpSJrv0ZhrffJiVVwSvUZBt+jP09wquEj8NGRJ0KQVq1WVQ3fq30wMYHzp/2qsg5
         ao8qWx2ToGv6XyJukDgWcaiJ1bJMOYOPTtuxGLMCUE/fyHu1i3Vzd0B0/lqv/KShmI
         buviRvznk9Y/Gk6/zWM3YFaAdOWdXRe6AJqqx/r3RAUvKh3EBMVTvKbtUfqb/f0XBa
         yHdy3fiBKlEPnxF/sSv22W7fcgiiujWIPPW6T6rOjBg4jLYfLqBHP1PxheYs3cg6Wd
         yaf3vojEgjllVWTa9NmxE2oLLc7u1iUJUQxKkeyx042JvDe28UuhFqYmJ6D714tLOt
         7IjHvqCd+Iyuw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id F32E2C05FD0; Fri,  1 Apr 2022 11:00:52 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Fri, 01 Apr 2022 11:00:52 +0000
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
X-Bugzilla-Changed-Fields: cf_regression
Message-ID: <bug-215788-11613-j88tWFpGUC@https.bugzilla.kernel.org/>
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

Jernej Simon&#269;i&#269; (jernej-bugzilla.kernel@ena.si) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Regression|No                          |Yes

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
