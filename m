Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF11CD4847
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 17:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjIVR2P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 13:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjIVR2P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 13:28:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B9FF1
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2023 10:28:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F53FC433CA
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2023 17:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695403689;
        bh=Do3lScztzYnA/DuHreuKeqCfSUX744DptsQjXD2k22c=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=sbRT3IbDveuUdlopfZ2ZRDAy7K5U8NgCocXm/syqaIJNkLR/4RDqZMH92sRQpijjF
         gqA9aO+2mFgwD7UWeN1XCACbK9JqcPTcrPw3F/XJt3SoeirGRtIgbpebPbG9msj5BJ
         HN1ZU9tXU00JteyiFFBCb6irv6RjencuCfkZlHKdEDa2T7Xyve3aCqN+juqkyy2VNH
         EIlv1vUccpWdk2QOua2FWk1KdSnEnVIivsZIAxCdP+XL7hyfdegw8v7dCXV5jTdB8F
         PyibsQOG5Hs0OMviU/+OvVCYDLIsmphGPFLyy2PfAEd7mmSfDY4Ef6BowFscEs43Hk
         +kjm/5pQTwAiA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 1A760C53BD5; Fri, 22 Sep 2023 17:28:09 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Fri, 22 Sep 2023 17:28:08 +0000
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
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215788-11613-DtmMrKj07L@https.bugzilla.kernel.org/>
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

Damien Le Moal (damien.lemoal@wdc.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |martin.petersen@oracle.com

--- Comment #21 from Damien Le Moal (damien.lemoal@wdc.com) ---
(In reply to Ken Link from comment #18)
> I am also experiencing this, on an Areca 1882ix-24 with firmware V1.56
> 2021-01-12 and arcmsr driver version v1.50.0X.14-20230614 in Ubuntu 22.04=
 on
> kernel 6.2.0. I take it the 5.18/discovery branch hasn't been merged
> anywhere yet? What more testing needs to be done? How can I help?

I do not recall if the discovery branch was applied. Would need to check ag=
ain.
Given that 6.2 kernel is not LTS and I am not sure what kind of patching Ub=
untu
does, could you try with the latest stable (6.5.4) or latest mainline (6.6-=
rc2)
?

Martin,

Did you apply that 5.18/discovery branch mentioned above ? It does not look
like t is applied.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
