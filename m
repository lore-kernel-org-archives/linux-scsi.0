Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6380DCDB465
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Oct 2023 12:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbjJNMOy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Oct 2023 08:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbjJNMOx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Oct 2023 08:14:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C921A9
        for <linux-scsi@vger.kernel.org>; Sat, 14 Oct 2023 05:14:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E78AAC433CB
        for <linux-scsi@vger.kernel.org>; Sat, 14 Oct 2023 12:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697285690;
        bh=IlK1xAzCP14RqKfCnOdYNxlKtR7x7lpXqtu9NYDzCB4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=l5T3FJUkrywxgVp6z2SVZQ8mECfautOV3c0hgXygonFoIf/pBygHciAki2taFG03O
         /f9kMS+b7wK/uySU81Ijfw4rMXu/9AVh0yWX+MfnimsYtFVLNsygrJYCN2u6m6wIGv
         G+6nbsW519Ao/fbI59RcRYZE2PgLestInKCAyHXXX5t9yxfq3oCyJnFgcUCV/qEXtX
         l3eaY4uv9m1cZW3phcS1zg9m85sa7CNbRi5VECk0RocVlSfEflUMZZwxGClkNVo37+
         jQSopciQcjSmEgYpdkkHYp/lqc7bOcX8OeaLY7KB35I7veRtF7KkIfOD60ADaKEIth
         8hjyljqDtHZMw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id BF43CC4332E; Sat, 14 Oct 2023 12:14:50 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 76681] Adaptec 7805H SAS HBA (pm80xx) cannot survive ACPI S3 or
 ACPI S4
Date:   Sat, 14 Oct 2023 12:14:49 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: risc4all@yahoo.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-76681-11613-qzHKyr9BqR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-76681-11613@https.bugzilla.kernel.org/>
References: <bug-76681-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D76681

DE (risc4all@yahoo.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #4 from DE (risc4all@yahoo.com) ---
Apparently the issue has just been resolved as my bro having this stupid
controller verified today. This needed kernel 6.1.57 to avoid a warning aft=
er
resume. We want to thank everyone for all the patches that have been sent
throughout many years for this broken driver.

Till today this product was not usable and that was tragic so
LSI/Broadcom/Avago SAS cards were chosen after that purchase. A decade was
needed so many thanks to Adaptec/Microchip/PMC for not caring about their
customers buying such an expensive HBA hardware and putting trouble in SCSI
folks. Two versions of SAS and PCIe have been released till this was fixed
going to SAS-4(24GB/s) from SAS-2(6Gb/s) and PCIe 5 from PCIe 3...

Thanks again to everyone involved in this, we can now remove the card from
storage and use it :)

Keep up the good work!

Take care

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
