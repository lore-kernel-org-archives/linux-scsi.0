Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC096C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 07:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACBFE610E9
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 07:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242465AbhIRHWU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Sep 2021 03:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242950AbhIRHWU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Sep 2021 03:22:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D12AD6112E
        for <linux-scsi@vger.kernel.org>; Sat, 18 Sep 2021 07:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631949656;
        bh=+uLZKxvFny4B+6RDljVPl5lteav72gGfIvi1uF3oMtM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Sx79Dw+d3dDeLPgk6YWurr7dvxEboIxeKHHE00lCKJnx9JUc95EkjnNEwpGqK1Ise
         UHUh+Dtz6VpwEjhdTV4LZfdtQ3Et/yigCOf/gK23mYvRXTvXq51z4W5yqAXJcqlU8h
         SNAFoi8ORBM4cP+MOk0anycbBr5FqJEeNeQShic2z7EtMrzr4Ydbv6zO4EneZVXgmW
         RTNygkr2NR1614wfaqm7770drV22G1DM0AsXnNv8P11w5cJ02yW+CFe1aqCn9ci4wf
         pkvNkmPBxrMVtV7Y0of4nqRQoXXr+zjIldCZCXBinyyoDZTC1rgtHhMmSwBb2rzsHJ
         6cq3QtQYvxPuQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214311] megaraid_sas - no disks detected
Date:   Sat, 18 Sep 2021 07:20:56 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: mravunko@yahoo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-214311-11613-sNLZWyiSRg@https.bugzilla.kernel.org/>
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

Nikolay Zaynelov (mravunko@yahoo.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mravunko@yahoo.com

--- Comment #3 from Nikolay Zaynelov (mravunko@yahoo.com) ---
Hi,

I reported the bug in the Debian bug tracker.

I confirm that in (Legacy) BIOS mode the disk array is not visible and in U=
EFI
mode is visible.

Kind regards,
Nikolay

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
