Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67F8C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Mar 2022 07:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbiC0HaT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Mar 2022 03:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiC0HaS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Mar 2022 03:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B2F220DF
        for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2022 00:28:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4A7360F61
        for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2022 07:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10DF4C340F0
        for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2022 07:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648366118;
        bh=ul7TAa9pf3HSG0YGK+50zSxe49kU6JIXqN9H0JtdVks=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LBM3q5eyE7p0srpFZkqaRnQh6/kmW+FooJrtZC7WD1wrCI2AGwcenBoVXjt4AFcda
         S1cYfybtqan8bV7jV4yWw3Kskoc/DP4eYDxJ7VCl1uBaTj8s7IuDhaA+FvWPpGXNAJ
         PuepHXq8fXQNjC4aVabIakoraYM2S8rbWQ1rIBJap5yQJsfW9aVLWH1LE+hkka2pU9
         TZiBKOS8x9UDxWmYigF9VneItECpBkgqfNGI7SRoATe3/5KtiouplXvQNnMtbH80v1
         CL/FUjyXaLEGXgovPtQZQsF5aNa7Pt60hTthWn/UJApNfRKsm/2ARrgvbUX+WVVAFO
         M6GhpirV8b9Jw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CD948C05FD6; Sun, 27 Mar 2022 07:28:37 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215691] mpt3sas "SMP command sent to the expander has timed
 out" cause halt
Date:   Sun, 27 Mar 2022 07:28:36 +0000
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
Message-ID: <bug-215691-11613-GBcBOsrxZf@https.bugzilla.kernel.org/>
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

--- Comment #1 from Badalian Slava (slavon.net@gmail.com) ---
Created attachment 300621
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300621&action=3Dedit
Another crash

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
