Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ECC7C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 18:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbiACSDI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Jan 2022 13:03:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46122 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233605AbiACSDI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jan 2022 13:03:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A48196112B
        for <linux-scsi@vger.kernel.org>; Mon,  3 Jan 2022 18:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19B24C36AED
        for <linux-scsi@vger.kernel.org>; Mon,  3 Jan 2022 18:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641232987;
        bh=yit+ov8dMsdOnElakJjoD1C1ZxTxszIcVnNPJKgmg98=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Y2YabVSBlgZ5AWS+Qpj9IE1TzML4kg7ZENRXCaKc5dCjfe584iDON8tj+edoWxK2U
         sHAXwKryjZGsN9QXjiUvJqDuZEUmT+D2IkrshZ58WCJM/7CkYoDCz5Plbjhsl7c+Y7
         vXCHX1CbXvswjBWPSn6Dqi+9Dtgos7cjczmi4MEF9CnQTvctUSwU2nhoFAnItnZtwe
         At0IGPPfxJvk9FVsQ4hWRqEyEFn3BsvzXHWG4ckp+M5zwjxiyAj8hhQYCBmMjo5IYR
         0HYI+fz+yAEaxnLPXtzamY7RUwLPL7eomHu9Xzbe2DgTFuQPhkeGfgHIocV41vgyV6
         P+8hAA7vUw25g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id EFD1CC04E57; Mon,  3 Jan 2022 18:03:06 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215447] sr_mod scsi_mode_sense() failure -> "scsi-1 drive"
Date:   Mon, 03 Jan 2022 18:03:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: cshorler@googlemail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-215447-11613-cVp1iZvQnv@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215447-11613@https.bugzilla.kernel.org/>
References: <bug-215447-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215447

--- Comment #1 from Chris Horler (cshorler@googlemail.com) ---
Created attachment 300217
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300217&action=3Dedit
SUSE Tumbleweed kernel with fix

notable by omission of messages (only error conditions are logged by mptscs=
ih)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
