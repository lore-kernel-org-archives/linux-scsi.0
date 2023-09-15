Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F124CD37AA
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 20:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbjIOUnA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 16:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbjIOUm2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 16:42:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590CC18D
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 13:42:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BDA84C433C9
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 20:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694810543;
        bh=wdjQ7c3+yRwwJXIuvp7CyRrTJhdYsP+gz7msoZ1BiW0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=tlxgDpp1YOJ4jy1lurz3Vbezi2bMwlCiiAaPnaUGAFigwVO2yPQnUemJJL4/huymT
         NyDXGLSn5xL/8fZpbdj3AQH6ZnD05dbjfzQJueeh41LDYp0Oa/7245/46KYB1K04Wo
         KD9MLkprTYK1ufmQMUPK9isZkFNbxkunQeNOYOhUzFZHQdkis3blF+s8oQ0U9nhvtX
         JrlNV2LGXFWSkqBvn261+k3GT0Ez+ECauoCMAFYqCeNLPUmEdX4hAUa/Q7plFtPwMO
         fUwkAq1D57HFoLERQ+kXnrGUfIEX+30pBWh9bV/41jnjHJRVix3lDjrYlNVnavBXaq
         gNmvgR/XQLOHA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id AF540C53BC6; Fri, 15 Sep 2023 20:42:23 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217914] scsi_eh_1 process high cpu after upgrading to 6.5
Date:   Fri, 15 Sep 2023 20:42:23 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: bvanassche@acm.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217914-11613-kYbTmTcuaZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217914-11613@https.bugzilla.kernel.org/>
References: <bug-217914-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217914

--- Comment #1 from Bart Van Assche (bvanassche@acm.org) ---
On 9/15/23 12:33, bugzilla-daemon@kernel.org wrote:
> The users loqs and leonshaw helped to narrow it down to this commit:
>=20
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D624885209f31eb9985bf51abe204ecbffe2fdeea

Damien, can you please take a look?

Thanks,

Bart.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
