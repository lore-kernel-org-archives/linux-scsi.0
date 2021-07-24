Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0179C4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 10:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76AF760E91
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 10:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbhGXJur (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jul 2021 05:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234333AbhGXJur (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 24 Jul 2021 05:50:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4667460EB0
        for <linux-scsi@vger.kernel.org>; Sat, 24 Jul 2021 10:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627122679;
        bh=ItbTCOyhD4ujLyH7yi1i+aPd92+sGUrx2dy0QPRqiPQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dg4SjLlxJGmxjIhNYiDswDXmS7wWan31gnWXQg3PTKavlav/cV0Z7gs/cylWidtG1
         HMZPNTZyvcvdMme+0Brqcot1WqXFB1nk7/tBH0lRRJCR1xMDJ5tR86IkUrPOW5iNIs
         DH8+y2rOR1B38a71ZKCpfiODQxTUsJBdzD11dEpDwaSf9FnQlxeGcPkZaq5wscvYt7
         RoyO2VmZo9GPOKTQeyIu1RV+WsEs+XJ6sCt031G4FqYNKaEdi/x98qxbqsvWuuqHJN
         ItjjrgYMslCzn8BAiVpjJz1noL/fQyaWVvvlHQQEys3A2Ph93Kw7NIgGA9HGlqhAi4
         KiIRS6sQwIRLA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date:   Sat, 24 Jul 2021 10:31:18 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: limanyi@uniontech.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-213759-11613-hv2KCI6ltO@https.bugzilla.kernel.org/>
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

--- Comment #6 from limanyi@uniontech.com (limanyi@uniontech.com) ---
I agree to send a 'DISK_EVENT_MEDIA_CHANGE' instead of
'DISK_EVENT_EJECT_REQUEST' when media event code is 3.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
