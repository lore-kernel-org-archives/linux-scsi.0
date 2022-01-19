Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B28ABC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 20:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357203AbiASUHi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jan 2022 15:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiASUHh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jan 2022 15:07:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91EBC061574
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 12:07:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 782FBB81A88
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 20:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4FAEAC340E6
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 20:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642622855;
        bh=j4M9wz/nntMVCjKWiAmUlnxqU+SidH48H1nuB5kMiRk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dV8N+dFUIEsDBDYc1qlaeYj/ZAVHz5IEUd3nRWFnfPiU/ZT55bYbGP5kN53vqASMI
         2wlhnKMYbaR4qLUHOd7MnjBClRr70vy3cPDXmZj2D+yIYQNpm0Ql8x9cKoWikGwyni
         RThK2nyIBlnaNDb9bGL5Tl3iMxX8go3swDYcAzCHVhBQVox/3YAbnyr9TdFyBVfUqN
         8CwlnJTW6pa92KwLqvUurp9U3+r6D2joe6wk9mf/CAWUWjozTG3QKHIHK0ajH26KdU
         khoEFcMPEeEMDbRHtpryZeolF0sldZXWrUWYULr6brguQLIS6/2ode2UZ5PDFZ5EQh
         F23vM5tecJYPA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 3FE04CC13AF; Wed, 19 Jan 2022 20:07:35 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215353] VMWare LVM partitions not recognized, sees base disk,
 fails to Boot
Date:   Wed, 19 Jan 2022 20:07:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-dc395x@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: richr410@yahoo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-dc395x@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-215353-11613-AbZJDGTa2s@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215353-11613@https.bugzilla.kernel.org/>
References: <bug-215353-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215353

--- Comment #3 from Rich Reamer (richr410@yahoo.com) ---
Created attachment 300289
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300289&action=3Dedit
vmware specs

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
