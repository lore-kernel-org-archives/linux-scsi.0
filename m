Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF9F8C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 09:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2E80610C9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 09:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235033AbhD0JBo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 05:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229629AbhD0JBo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 05:01:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1576E6100B
        for <linux-scsi@vger.kernel.org>; Tue, 27 Apr 2021 09:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619514061;
        bh=aKP24SWQ9REmFt2skRuCvdL1rP7+Da+KYRaKxx4RT/k=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=tcFc7rDPCkbc35ED4YllI7isxTJRht06UxGHlt4DqXj5yc6Fr9ej92Zs20hZl+WI4
         piIGJ6DkOqHGsb0khRc5iPdsnZ+n5gsJzMVOdG7FbH+OBC7QGQbeK7IcxoxWUjkIXK
         +KWBo44QunfOeNv5A+C31fttssp4K5htSkpNwAC7FTrSrr+obvJHBoeKbGyP/90EwB
         aL0u83syBEzHfUXXgTN9oPlqegCeMg+0rhcwHyaPh1/EGQ1z7Opof/iRhfS965Wyf0
         YXa+FKZwo2KETuuRhYeGeqhg0IR27YT0JmEiYhKMowlRN7j9c5tWGJs3ZOSrvde9/a
         7DyZNxxOBcoeg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212759] NvmeOf (nvmet-rdma) cause crash with first step connect
Date:   Tue, 27 Apr 2021 09:01:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: NVMe
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: slavon.net@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: component cf_kernel_version product short_desc
Message-ID: <bug-212759-11613-kTC7DZfS2U@https.bugzilla.kernel.org/>
In-Reply-To: <bug-212759-11613@https.bugzilla.kernel.org/>
References: <bug-212759-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212759

Badalian Slava (slavon.net@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|Other                       |NVMe
     Kernel Version|5.11.14 - 5.11.16           |5.11.16
            Product|SCSI Drivers                |IO/Storage
            Summary|NVMeT crasdh                |NvmeOf (nvmet-rdma) cause
                   |                            |crash with first step
                   |                            |connect

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
