Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF15BC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B213610FA
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhD0JA1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 05:00:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229629AbhD0JA1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 05:00:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8FF52610FA
        for <linux-scsi@vger.kernel.org>; Tue, 27 Apr 2021 08:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619513984;
        bh=spUNcmzvoEee46hEa8Ba/dp45DUhfFzcwQc7uucgh3A=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=G9TGe0ZQgsIVsUq/gOP9lgLtcba0j0Doq8I+DYPQD8wVcDDFmHpgDbr+yuCOGlNVj
         Gtt7ot4vRSebZ3UxLvIdcH7leguKn0NSQFy5HPwBawUH5NNb6MWMtQYBJE7MDHhbWX
         8NbqA7XsAIaB4Cx0pCU3h3ssDVhPYuEsyYtTgER7P6WvgZ9a/dW8syo/ZHPb4WgwX7
         eYO+46CeR4A0wvu3KupKv3NJCkkUh5QLD7xWWsDkzRGstE8V0d0R33IgdtdJ6Obm64
         G2r/Wl+YBestE91xjov0jecX5NgSVuo4i1kX5X/yGPaqJXuzz4VjEdh+fwTyz4IG+J
         mpIylfd9Ko82w==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212759] NVMeT crasdh
Date:   Tue, 27 Apr 2021 08:59:44 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: slavon.net@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.isobsolete attachments.created
Message-ID: <bug-212759-11613-7RSpKZROqz@https.bugzilla.kernel.org/>
In-Reply-To: <bug-212759-11613@https.bugzilla.kernel.org/>
References: <bug-212759-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212759

Badalian Slava (slavon.net@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Attachment #296465|0                           |1
        is obsolete|                            |

--- Comment #2 from Badalian Slava (slavon.net@gmail.com) ---
Created attachment 296481
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D296481&action=3Dedit
crash

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
