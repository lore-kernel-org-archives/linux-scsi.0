Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2964CC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Mar 2022 07:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbiC0Hag (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Mar 2022 03:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiC0Haf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Mar 2022 03:30:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A271926108
        for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2022 00:28:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D3B760F62
        for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2022 07:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5832C340F0
        for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2022 07:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648366136;
        bh=0XAb+myNfob3nsWnzHRLSYKDQ6RJOrtfPy/eSKp7EGY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=katpnlALpIOELxBaeEYQkdHdjkNJljY5HJqJBdMU9mwZBpmGGcKUDaUkxfBe6rczC
         6lQ3Fs7IrijJtbjALTY48GtIK/LoBrFV7WO+bHgSPTdxNUhkZeOJbma4dfOTxsGqVF
         5/5huezignGdLRiICpEQjMXzVEeRU8q0RkrQGwgfKnSQMkFR3ZGn1VITTeT+ex5eWX
         412GN17wFCc5QfkA2uHVgSLviGDNG+K/++u8myu8yLPuR4kRb430tAxAf7FAFzeDzK
         gYDnTivOlLxeLin0A7mcGfjzFYTKyLoMJUfrW9q/Wn0Hx4M8d2xVcNvBSKuof7u3gI
         +hNHqe9wdnxaA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 82537C05FCE; Sun, 27 Mar 2022 07:28:56 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215691] mpt3sas "SMP command sent to the expander has timed
 out" cause halt
Date:   Sun, 27 Mar 2022 07:28:55 +0000
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
Message-ID: <bug-215691-11613-49oB2la6f6@https.bugzilla.kernel.org/>
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

--- Comment #2 from Badalian Slava (slavon.net@gmail.com) ---
Created attachment 300622
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300622&action=3Dedit
Another crash 2

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
