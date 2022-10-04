Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15063C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 08:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiJDImC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 04:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiJDIl6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 04:41:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D78A193CD
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 01:41:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B6D0B819A3
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 08:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF4CAC43149
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 08:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664872914;
        bh=hGMWLIS65teipO6riN4cIU+mVd+VcJI7JPrNbglgEyU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=uWaaUIsRk27+zL7RwdssZyGlj2h//+3xRz2yCfreZ98EkmTVHQhoFPgbwg5KpG2bC
         H6a+YhIpYP9bRMVc2z8W7v45Xq21TIMpyXvZDvMVBloa7nE+J2w+ai5SFInyrfyORr
         xSwNrUDf5wQK46wWjx3VOvgusdCB6F/N6s8qcx4XGg2U0dC/xK0Mn3G8FtJRb+kSPC
         L0oybbsS3F5Ygcx/nr1LRH0IEt2PlaZd3p3qxeHfK2Qqn+zOOk56q5COoCcrZxB1ox
         NDm53kR1MJtzsfd46whGEFJF2ct1D4eBPXoX6hp2UHRxF2TauUtkQhKn9kGUymoChF
         0nNxMoWWGqRBQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9AC6BC433E9; Tue,  4 Oct 2022 08:41:54 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214311] megaraid_sas - no disks detected
Date:   Tue, 04 Oct 2022 08:41:54 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: sumit.saxena@broadcom.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-214311-11613-5vFqM8SPf7@https.bugzilla.kernel.org/>
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

Sumit Saxena (sumit.saxena@broadcom.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sumit.saxena@broadcom.com

--- Comment #5 from Sumit Saxena (sumit.saxena@broadcom.com) ---
Driver fails to get controller information from controller firmware which l=
eads
to the driver load failure and disks don't get exposed to OS.
It may be the controller firmware problem. Please ensure the latest control=
ler
firmware is flashed. If the issue persists with the latest controller firmw=
are,
please contact Broadcom support channel.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
