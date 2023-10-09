Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94982E95A8E
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Oct 2023 08:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbjJII3w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 04:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbjJII3v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 04:29:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063788F
        for <linux-scsi@vger.kernel.org>; Mon,  9 Oct 2023 01:29:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 939BEC43397
        for <linux-scsi@vger.kernel.org>; Mon,  9 Oct 2023 08:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696840190;
        bh=sJAkmWorVPGM5sqPhmmJT+gXQNbd16eVgjQPXCwo5Uc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=SEtVRMysRCr08qK40Kw9CCXP5ZjPI4yE7AgMfjHMAfgKMFQwraoFLXR0MKiKlyZo4
         sDHX/fGFh0ip1FBaGbxtx0/Uf0do/EkmF+B7eqhnFEWhTZcyLZNKY8emlCYXDdgNuU
         k+HEggi+Y9fL1+YadMIVH1iaaAHc7B5wkSqP/J73Ce0lDCZaSoHMRjhvxO8ecCZSQU
         mqJ5wPcxxcyLV70NPniAy8XTr3L0xGDhPVLdp5++NE9dLZWAYJuBoH+PkFpZzatYed
         zcVUX+YqiZqGpVUA1+RRY8bzQIubcklpRjKoe3KInuA8ciL7cLU0mVTbg6R1FVecLb
         WsS4vY08mE2HA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 84E2AC53BD0; Mon,  9 Oct 2023 08:29:50 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 209177] mpt2sas_cm0: failure at
 drivers/scsi/mpt3sas/mpt3sas_scsih.c:10791/_scsih_probe()!
Date:   Mon, 09 Oct 2023 08:29:50 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: growthstarboard@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: drivers_other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-209177-11613-jTVcQ3wgIO@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209177-11613@https.bugzilla.kernel.org/>
References: <bug-209177-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D209177

Lynn Davenport (growthstarboard@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |growthstarboard@gmail.com

--- Comment #7 from Lynn Davenport (growthstarboard@gmail.com) ---
(In reply to Akemi Yagi from comment #5)
> This bug has been reported for Fedora (kernel 5.8.6):
>=20
> https://bugzilla.redhat.com/show_bug.cgi?id=3D1878332
> https://penaltykickonline.com

I can attest that the value "mpt3sas.max_queue_depth=3D10000" was effective
there, despite a few peculiar and maybe cosmetic issues that I'll transcribe
once I have them in text form.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.=
