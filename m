Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 355E5C38A02
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Oct 2022 09:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiJ1JMl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Oct 2022 05:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJ1JMk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Oct 2022 05:12:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9F277541
        for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2022 02:12:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80D2FB8289C
        for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2022 09:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2878DC433B5
        for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2022 09:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666948357;
        bh=eco52whOI45VpfbrmwHO9S3FlHk4X6Idj1Bx5hVDKvM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=gL62dKdMzKY2eWO33pdZ8MyZdcsq/zV8apGaDnH51vILm8SFZ7UXn220GzrnBgCRL
         HcsXBk0t3Iha/jgXpbw+l2PAqNmyZFJup/ds3/1HuWTbQlRv/lM0OxDF25IX4J51Fn
         FO9KA3zM+AkyN9HhbjcJlLgukNR9ILXBFwLdltMy6tHYm4uxNzyPFOpxQVIDX/Ir94
         xPPrubcq2h6BYLvpYhis+7sqTyM8l9vJ6ZySZWfNTFaMxYzQffspHKV0S8nk55JfFu
         GcMK4Kzj66q1u84SURBU6mkVvWqRA+6bQ7xnbNtxnnM9w6LHiB59XcjE1pRWcNi52c
         QZSsC8RlaZTeg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 17169C433EA; Fri, 28 Oct 2022 09:12:37 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214311] megaraid_sas - no disks detected
Date:   Fri, 28 Oct 2022 09:12:36 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: rollopack@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-214311-11613-VdA66YQeXZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214311-11613@https.bugzilla.kernel.org/>
References: <bug-214311-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214311

Gabriel Rolland (rollopack@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |rollopack@gmail.com

--- Comment #7 from Gabriel Rolland (rollopack@gmail.com) ---
Same problem with the Dell PowerEdge T140 with LSI MegaRAID SAS-3 3008=20
[Fury] (rev 02) and linux-image-5.10.0-19-amd64 (NO UEFI)

No problem booting with the old 4.19.0-22-amd64 kernel

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
