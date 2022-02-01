Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F005C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 18:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241892AbiBASQu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 13:16:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241854AbiBASPd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 13:15:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CC4C061757
        for <linux-scsi@vger.kernel.org>; Tue,  1 Feb 2022 10:15:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52F24613F7
        for <linux-scsi@vger.kernel.org>; Tue,  1 Feb 2022 18:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA434C340F3
        for <linux-scsi@vger.kernel.org>; Tue,  1 Feb 2022 18:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643739332;
        bh=s74a3nOHIjj6AhpozJokRUttRnWbnHfkMNIWmnu9DAg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=POYsG4xPuxni3aA3WOstIBHlcA0PMfeGHspUlvgwbsOiyd1E1j6WwIXZ+chilMmym
         YiqucWK9oT2xMNamRZd9L9s7PdHytXGo+T0t1bnq6V6CfLYleCqQGcOOFQR8H8ptnk
         5Bv78KW9zol8RjXMY0pcRrKLGCs4lkD2PGfSUY4yJ3cuEUgPyA+LpNZFMEMXv0ZWA3
         ZigHGgphhv05aCtT2SoBd5lTYWummVnxqvwdMz9M24hZU6rfrl/WPnm+dDONas9oqq
         41Z9V/ALgDh5Kn4zzs/3/Sgw9AV8ud0BqrvbvvMuA0vD2aq0c+IrhUbPrx8RVVTpHM
         ayutPSRt5I8OA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A6F5CC05FCB; Tue,  1 Feb 2022 18:15:32 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215353] VMWare LVM partitions not recognized, sees base disk,
 fails to Boot
Date:   Tue, 01 Feb 2022 18:15:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-dc395x@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: toracat@elrepo.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-dc395x@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215353-11613-zAyt0W5KNe@https.bugzilla.kernel.org/>
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

--- Comment #9 from Akemi Yagi (toracat@elrepo.org) ---
This bug affects RHEL-9 (beta). A bug report submitted and being tracked:

https://bugzilla.redhat.com/show_bug.cgi?id=3D2048178

Unfortunately it was made private, so not visible publicly.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
