Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_ABUSE_SURBL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E54C636CA
	for <linux-scsi@archiver.kernel.org>; Sat, 17 Jul 2021 21:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1B0C610CB
	for <linux-scsi@archiver.kernel.org>; Sat, 17 Jul 2021 21:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhGQWBB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 17 Jul 2021 18:01:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230210AbhGQWBB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 17 Jul 2021 18:01:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2F0EF610CD
        for <linux-scsi@vger.kernel.org>; Sat, 17 Jul 2021 21:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626559084;
        bh=q4JwTb36RZBYUmDGiLRWrNL10leUVifvMXOKkQARsd8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GO+51b86HaiqnTUjzfk/0LY6f4vCiDvGtCTQdAsG8/6jWk+r8JdS4wbBY+pLZHzFy
         K3CQLuQqtxX+kbQXKfGNcJlS6sI90AoULJycG6taxbkRr/Ze0I4mtZh3s75Ym/DQYG
         h9WfK1otKjvx821JoGhID0arts37lcwIoDC/vml5Caqw+hqCoTQTeb1FbLwg1EbpUd
         6dSDTzADgmGUdZWbou1OlSgmJI6ouh5k9WnUy2EiAHn9gEftdyi8olEwoASvV1F5b9
         TUrnqGKnnwFkcfLrcuB8dA6nppzFACP5gp2K9RJOoIvWWyDeDOSQo103tlkB7GW+pb
         EuB9QCR8cOS6w==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date:   Sat, 17 Jul 2021 21:58:03 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: xalomo4655@eyeremind.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-213759-11613-NnUvk6nlc5@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213759-11613@https.bugzilla.kernel.org/>
References: <bug-213759-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213759

xalomo4655@eyeremind.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |xalomo4655@eyeremind.com

--- Comment #1 from xalomo4655@eyeremind.com ---
Also seeing this problem on resume from suspend on a completely different
system than the above user's system.

Can we please get this fixed ASAP? Its a very annoying issue. Thank you.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
