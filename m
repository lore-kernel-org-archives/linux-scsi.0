Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA37CA0FFA
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 16:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbjIEQGf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354842AbjIEO52 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 10:57:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E131718C
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 07:57:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 478CACE1193
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 14:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F4BAC433CA
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 14:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693925841;
        bh=XObzX+ytbZOJh2K3LNoiuh0jTAru/izbtLkTmx5Vs9o=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=bnK8PtUjgy49OV/ZlhjslTFqKS1SB/02s6Isuk3v0AzhTOkVLaOMa1014bzqa8FDx
         wS+t7Snfg7UlSjEKVPtiCp4y9Kx5THwYYmxLxaGPgxwg/e9Ec02H9v8BguqfY8Aa/S
         6qr7PH3Otunx/GX10EA4Ji8K4Yg4IVU0WDuRDtOZI9v5nyn2AZ4T/UWss6gRahXo2z
         le/GrC+OoH20Mj2noZvKM89uzvsYZtRZJQZEHxr0YmV97LY3/RcQxPJ9fMFMEpXR5w
         4iNWbon2AbjP/TI836ydjXZTVJfpM+IQ5obIVV/O/KoWD5uYpIG3vD6/rMXqmuogVI
         G0q5JxNfW/FYA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 82C46C53BD4; Tue,  5 Sep 2023 14:57:21 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Tue, 05 Sep 2023 14:57:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: thenzl@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-p0seZQv2JX@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

Tomas Henzl (thenzl@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |thenzl@redhat.com

--- Comment #14 from Tomas Henzl (thenzl@redhat.com) ---
Sometimes this might be a bug in controller's firmware, can you check that =
you
use the latest possible version of the aacraid controllers you all use?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
