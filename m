Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86DBAC001E0
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Oct 2023 11:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjJULVf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Oct 2023 07:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjJULVe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Oct 2023 07:21:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2ACD65
        for <linux-scsi@vger.kernel.org>; Sat, 21 Oct 2023 04:21:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C705C433C7
        for <linux-scsi@vger.kernel.org>; Sat, 21 Oct 2023 11:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697887292;
        bh=jwjT+ktaam5p5hMJBn3lHHJ4hkK7mo1KXf0Xxg8/U8E=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hC40k1qXahwHWFstZ01IkZMYpi8W5bpaRetFCxgIHQEetUYyNZFAXt+KNmrtuCMtT
         iTQzQXbRGDh4gWQmpuKvWbgVzhm1wibb6vO8rbsjks+o/RYDxajZSXYsKMj0K+WBtY
         mCRifLZmXLF0rd3+UKLZ3hH4snNn8t6jPYSyRKiNsF3+BbxSX8db+1CrBrwM05oR9g
         PHhAZFCsFyZSd1GRz7BoR/bDcMnfg1ZqQGeBjq/kXavxNL8tnEjrk8uYmv2mWo2nl3
         b51vVITOGegJRTwVKT2e5QtnMTN8rcmd/1lG158Yha9N+JAg+1dUMlhV2iwzp6OF0f
         CtNCyp/CYjAGA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 269E5C53BCD; Sat, 21 Oct 2023 11:21:32 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 218030] Marvell 88SE6320 SAS controller (mvsas) cannot survive
 ACPI S3 or ACPI S4
Date:   Sat, 21 Oct 2023 11:21:31 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: nickosbarkas@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: rep_platform
Message-ID: <bug-218030-11613-AgAbKYeu6V@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218030-11613@https.bugzilla.kernel.org/>
References: <bug-218030-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D218030

Nikolaos Barkas (nickosbarkas@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Hardware|All                         |i386

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
