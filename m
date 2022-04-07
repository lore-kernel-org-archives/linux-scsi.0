Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25975C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 04:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiDGEEB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 00:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiDGED7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 00:03:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A8365E0
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 21:02:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADCA7B826B1
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 04:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48F5BC385A4
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 04:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649304118;
        bh=t826V4OpJGfEA+SWf+sbx0LxmhPLBU12MWGbNAbn6SQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=AhfWf/auBQqLvzsFAvz6yVnw+vkglsFlzUt6PvzBqw1Yqw4l1BsWo+euWaSLspEHK
         NjU7ZcKOYIj/NoGkHY8cf+DlB8im9dntF070tZ9djIWgEB/Lok1xtRHt5xqK0equad
         Ol10dB6pbJOBMC4lrgNsde9WqTf7+KjWdiVUCE+bXXZ+USKuSp+JEamaMoQJocSNiY
         5d4T7JyaG2cv6sfEM5PcYThgPyFmUUxwkCmKF2GEI+j6aKkrwlZJ6D0UUUWnwffSnX
         TDzyB48eG3OLNxPwewYs79J29hKsx0s1RQ0Qk/OzBJyNXkz18mWQP6caeZTOLTEsCq
         1W8YaeimWMg4A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 31E2BCAC6E2; Thu,  7 Apr 2022 04:01:58 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Thu, 07 Apr 2022 04:01:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: damien.lemoal@wdc.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215788-11613-gnK0QHkS6o@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215788-11613@https.bugzilla.kernel.org/>
References: <bug-215788-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215788

--- Comment #11 from Damien Le Moal (damien.lemoal@wdc.com) ---
Martin Petersen (SCSI maintainer) suggested that you try out this code:

https://git.kernel.org/mkp/h/5.18/discovery

to see if it makes any difference. Can you give this a try please ?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
