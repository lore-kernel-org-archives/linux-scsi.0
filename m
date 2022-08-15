Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB9FC00140
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Aug 2022 13:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbiHONgM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Aug 2022 09:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbiHONgK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Aug 2022 09:36:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C0E193F0
        for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2022 06:36:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25A24B80EBC
        for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2022 13:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E74D9C43159
        for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2022 13:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660570566;
        bh=9xCLqoG13PyvHI0DqL2wOc7QqZnFsDpz8WgplU+r07c=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=j/HcZ6WiIvELk1xYwt6/9+6DAKh5jvsuCjy6Dc1L5oOKKkhyrhS8mqzMI09QaLwDg
         suCt7FWvlmbLmGyPI+X1Y8XuLwYhhYfrvhwc0nSp3oqqX6rZ2pDGPhgsiTWJj+iIcF
         f1fszNO7QXhEbUGjrokYMzWJ2aDbgEvu9j5NVI5vSK3HG2aIGwYZksd6SBzYrDZ9CQ
         AjYl9Gt+gMAtOFcEfadaCc6XdTNSODJg8IyEQkor4h6be2WJGujEQDdlmzJI7C4hxh
         XsqIl6hUYZgRBo8R2gomkXqjN3jZCr7fM8k7wm1H7B9XpF918/zY0DGuDz4IjalxDl
         mDvucsNep2hjg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D8B6BC433E6; Mon, 15 Aug 2022 13:36:06 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Mon, 15 Aug 2022 13:36:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bvanassche@acm.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215880-11613-6nlpQVo23k@https.bugzilla.kernel.org/>
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

--- Comment #30 from Bart Van Assche (bvanassche@acm.org) ---
I think that commit 88f1669019bd ("scsi: sd: Rework asynchronous resume
support") got merged in Linus' tree (kernel v6.0-rc1) about two days ago.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
