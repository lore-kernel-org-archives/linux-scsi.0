Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 603CCE6FE2F
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 13:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbjIVNt6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 09:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234147AbjIVNt5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 09:49:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102FAE8
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2023 06:49:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0461C433CA
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2023 13:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695390591;
        bh=psNfKkpA4dl9/pjsnOJqZY4WwtKKACatv3nvKzzySTc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=BnS/CT9UfBs72o+zqczVfADpjK6y380sQwYfM7x+6yBfbYVqAl1rJiKFRJmH1mRfm
         GS6xTHR+tkRotUuEPcCRt0MHKXnrPImpSWIo0AR6zZ3YRLavXiTAaQZ/M2imjfElii
         VVAOBTOKIYCl8kjdKM0Uirf33oCRmMdS0BPdHhk1Ng+KC1ha4L+YztgzWiYCJu49uo
         mpY0BGs640LFnIl2ezMtxHukxbSTFyrPTG8RD/sWqXrONLXDbbzOaL9/LliEb4g6wf
         0cTzZ9hrJWkCQGm9bxnOc37dJHeE7mpAaV4M8W6AAZWf7i1XCCDSdtzrmtzkNIPoAH
         cXWIMxDnn26tQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9BD81C53BC6; Fri, 22 Sep 2023 13:49:51 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Fri, 22 Sep 2023 13:49:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jernej-bugzilla.kernel@ena.si
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215788-11613-Ki1mDLERLZ@https.bugzilla.kernel.org/>
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

--- Comment #20 from Jernej Simon=C4=8Di=C4=8D (jernej-bugzilla.kernel@ena.=
si) ---
FWIW, I've been running bcachefs kernels, and I haven't experienced any fur=
ther
problems with arcmsr on neither 6.1.0, nor 6.5.0.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
