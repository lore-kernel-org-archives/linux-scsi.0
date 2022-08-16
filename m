Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22381C25B0E
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Aug 2022 17:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236066AbiHPRMB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Aug 2022 13:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbiHPRL6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2022 13:11:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6AF659EE
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 10:11:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5306661306
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 17:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD113C43149
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 17:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660669916;
        bh=XAb7yB1LVad7vN04DjKFo+fL9wIrMoV5SKz+Ellhja8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=KKYEPoE0WOJb2KhVgWzOBcGwj0j8+Lrg/HpAZ+HYWmv+BQJemfZI6WBGUkMbWqRM2
         jh8jLxHJByzniBWQgUFjebprh4S9KR9vHfsIEdNsBU2XjL2QKlGP5GppTzbMki+ElZ
         YqHqhtsBu8qJQdyOH0HdxO7KS6vluXtH0W95PryQOJ+NOzMAFnhkGXthElvcr7MdKd
         l5QWfL7hcdRSIeGVn0oei+3CdXE2K9JTRgyjJtaJKDVxuEu7zdpVWVxDOsmtSXlagH
         VkfuR7nmB2FLxcONj1f8gC6YGX1g1iltnK3diFU4og+IO1EqZMVkL4icmVF/FjFB/c
         +Uob6Yq4oPWKw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9F3D2C433E7; Tue, 16 Aug 2022 17:11:56 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Tue, 16 Aug 2022 17:11:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: gzhqyz@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215880-11613-ecGSlwhUeq@https.bugzilla.kernel.org/>
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

--- Comment #35 from gzhqyz@gmail.com ---
(In reply to Damien Le Moal from comment #32)
> (In reply to gzhqyz from comment #31)
> > Hi, on my laptop (500GB SATA HDD, Disk model: WDC WD5000LPVX-2), commit
> > 88f1669019bd cause system hang after resume from suspend and reverting =
the
> > commit fixes my problem.
>=20
> Can you try kernel 6.0-rc1 ?

Hi, the issue I reported is found in 6.0-rc1. Here is the kernel I am using
(without commit 88f1669019bd):

Linux archlinux 6.0.0-rc1-2-mainline #1 SMP Tue, 16 Aug 2022 03:18:24 +0000
x86_64 GNU/Linux

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
