Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE904C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 04:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6B77613CC
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 04:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhDWEmh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 00:42:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231542AbhDWEmh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Apr 2021 00:42:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6CD30613BD
        for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2021 04:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619152921;
        bh=tqmWloltMBXi+fqQTqbiDS9gwqBu94Ulg+pNiuvx10M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dSUaA80Ndcb4nTMG4vgrjg0q3IewmlAJ0q16oi9413TG1ujjkTj7XITlQy5UllWIe
         7Q9mg2/je+SW6MhNzxbD8PCK2mc4g6Hfk/Icph1DRxaB3B9CoOR+Q2+IGcUwSMn73H
         a5oGSxD4uUuAOJ8IdkrvlzyPgyM6Tz7TBrsaZXnKamlqkuQZi/3q35PooHswkWwtDD
         GySb6YN7ybO5tpNyv4NsnahzmyaNxLb4+AL52vfPpuEr7wERm+A4U2PXY/iex5Wiqh
         QoyRAxifJeGsBpGIhiZVHCtCS4RreyGvR8t6rHcNtNNBHs4uyJkITc5WIrWfiTJWPn
         7RLGk6OBUT7Aw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212759] NVMeT crasdh
Date:   Fri, 23 Apr 2021 04:42:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: slavon.net@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-212759-11613-1Zk27WjBJw@https.bugzilla.kernel.org/>
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

--- Comment #1 from Badalian Slava (slavon.net@gmail.com) ---
Created attachment 296465
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D296465&action=3Dedit
crash2

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
