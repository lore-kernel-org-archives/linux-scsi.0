Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A49C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 02:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8B2C61582
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 02:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhC2CT5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Mar 2021 22:19:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229861AbhC2CTo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 28 Mar 2021 22:19:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 948046192B
        for <linux-scsi@vger.kernel.org>; Mon, 29 Mar 2021 02:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616984384;
        bh=7Ngd7XmlxEKBtVk4ZRQFhMVtbzT4oaoVeOqJWAkQI3Y=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=oAR+DgVRlxWGpBFy8Hhnq6i1QPAo7+oAeTUF+YLzlIsiHUW5zJpZQH5QDC1XHIfkn
         dD7XNvU/BP+aNC/htzI5G8zBO9i4mS2bB+lcC45KyOxqrmzURHPXKjOltyJPXZ0qiO
         issW2NSDNZgQ+6DydAmmi4HKI+PLtAJSiFGG9oZJXf7trdIADzdCYZCrFvvrXO0u6n
         ENXGyraCvgXY3z6u518aw85YWSPv5iUrjVYL6TRMErROsqA2Kis0qnCLjX3i1FUWiH
         iRsmwb1wBcRDdU8FGW1AjfAhUjaWhz0dHfk8vMBFL7WrMaoMT40IujhIN14Ui4A1L1
         1aOefTc2QIZQg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 187221] HPSA resetting logical / reset logical
Date:   Mon, 29 Mar 2021 02:19:44 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: vsudoblog@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-187221-11613-tH3ihbuP4r@https.bugzilla.kernel.org/>
In-Reply-To: <bug-187221-11613@https.bugzilla.kernel.org/>
References: <bug-187221-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D187221

--- Comment #3 from vsudo (vsudoblog@gmail.com) ---
Update my website is: https://vsudo.net

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
