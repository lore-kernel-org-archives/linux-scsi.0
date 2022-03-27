Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DDDC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Mar 2022 07:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbiC0HcO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Mar 2022 03:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235593AbiC0HcN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Mar 2022 03:32:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB2A39BA3
        for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2022 00:30:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 485B260F61
        for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2022 07:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF6ECC340F0
        for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2022 07:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648366233;
        bh=3KxBRaSQ0uTJrRsw9pgfRtJuGHjytk4qiM1Hp2Ya3Wo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=j3qZQ157g3hyHEClecHJR6ABD2y5usp+4tPnI6e6yw+s2ZRYVoUfS99naNWpnmZv2
         KgqXJ7T2rRmXBbHSgI6NxxtoYHnat66wFuxgIMMt6Eglv1AgFM4HfGkusOIE8MSHRy
         6on8e/hDlIYdrI/kp4U7Hlf65nBxQB+lmdYYPEoPZ7m37Chq2/S/9QpPN+hSDsMwZ3
         WH2acbi7BcTr6S36mLWPNLoFeZwvJKP4lqd6rX/K6nSQGYEMdZHpoaVbhqtS8YSy2V
         C5vP4JhGhGeOrWE7OhXF1leAXgTnOi1MSdlfNqapgj7ABF4rT01D+LX7pDIozg2gXa
         trCUNR7/xd9cQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 94C75C05FD6; Sun, 27 Mar 2022 07:30:33 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215691] mpt3sas "SMP command sent to the expander has timed
 out" cause halt
Date:   Sun, 27 Mar 2022 07:30:32 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: slavon.net@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-215691-11613-E35Toszzkv@https.bugzilla.kernel.org/>
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

--- Comment #3 from Badalian Slava (slavon.net@gmail.com) ---
Created attachment 300623
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300623&action=3Dedit
Another crash 3

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
