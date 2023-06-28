Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A83C001DF
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 09:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjF1Juu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 05:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233856AbjF1Jig (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 05:38:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA141FFC
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 02:38:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09E0D60F66
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 09:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19777C433C8
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 09:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687945091;
        bh=8b254m9yqevc/FqTKQdgDtrZ9zvjsyt2uYOAwpazk28=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Tafyp1HQvqBbiiRQX5OekDFSucjjxT21bKFhcC3+IJ6K2Hjq8AwDSxTah4YQhdugh
         D4tgY03QBBgJwqUjtzozgma0GPjg+5b3aqQJKVQbh6zKZ6hdwBKtLDztvNfDU3aWfq
         CIViyu/LTEde0MisP2uyFXsmoGVWLit/DlA5+2Ve7fW53Ez1Jnr5D2rWvbxbCHGRth
         wpafcVAz2JmfHdun3TDRxgN0t8S0vobJa9GzZXlLLL3s+q0CQRwoR6ZcNIf6zIPNGI
         HF3gM8ygbgUh0a1aq+RHszYDBuUvDoIAQKq41+xRYgTp7aov+Y6VfHugI312lh4ej6
         hWyl3klaLrUVA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id F2E7BC53BD2; Wed, 28 Jun 2023 09:38:10 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Wed, 28 Jun 2023 09:38:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: pheidologeton@protonmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-GayEfeaVTQ@https.bugzilla.kernel.org/>
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

--- Comment #5 from pheidologeton@protonmail.com ---
I do not have another server with an adaptec controller, and downtime of th=
is
server is highly undesirable. If there are any 6.4.1 fixes, I will do a kex=
ec
from 6.3.9 to 6.4.1 and report back

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
