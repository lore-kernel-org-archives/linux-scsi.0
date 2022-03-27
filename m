Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D081C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Mar 2022 07:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbiC0Hdi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Mar 2022 03:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbiC0Hdh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Mar 2022 03:33:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2655B312
        for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2022 00:32:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C06B8B804A4
        for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2022 07:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44310C340F0
        for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2022 07:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648366317;
        bh=uoYwAQWySIzk7hGUSPUb7ldqEMMFw+mMYLnmcRuPZVY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LpKLFPPjGF0NeVXKoGgS1YGGtDSjPGlQcnfpP4muLaAN3OSI19Bof7CkcEILpz/bX
         1gMUSlQdziBq4bQWHwtZvKUnqZWvIiusq0TfCRQUI8/ZA8Rv9gGDCjGYs6O5EvfyqH
         3d2xFzf9C1Vprh7YSlMB7e6bBXt9wR/hJRkbyV68dO+Rusa73xCdNj/uYHHrRKsRTI
         Oqdb6U7IfYE5nSx/EyCqPr5/vsoAkyp7qeEmGs7i4Ix4dzJM9dq8jYMkE/1GBzznUS
         tucWgtzMcsecEjgvV0RFpvy7JjHGNETOFQIIgO8hdXbijn9oL6SUKXrwhpzqxu9Bnl
         1fVjpNEGwcd9Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 1A294C05FCE; Sun, 27 Mar 2022 07:31:57 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215691] mpt3sas "SMP command sent to the expander has timed
 out" cause halt
Date:   Sun, 27 Mar 2022 07:31:56 +0000
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
X-Bugzilla-Changed-Fields: cf_kernel_version cf_regression
Message-ID: <bug-215691-11613-RGk7j6PoZq@https.bugzilla.kernel.org/>
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

Badalian Slava (slavon.net@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|5.16.14                     |5.16.16
         Regression|No                          |Yes

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
