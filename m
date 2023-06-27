Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B41AEB64D7
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jun 2023 02:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjF0CL1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jun 2023 22:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjF0CLZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2023 22:11:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF872171A
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2023 19:11:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6300360FD0
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 02:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BDAAAC433CB
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 02:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687831883;
        bh=FBWpcl2VT6i1hm4+/x3nAEMtRy0RuAzdob0UIgWnUdc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=N2Bno0IqdpEQndo16VDxBuCA+HMwT90qCdFduAYE8plPZCdowttb1anq4kT6mwzId
         WLqaDUJ81Mke9ueSnEsfXJwNcmgrOqQJBrdVPthojMccqCzhXckygDvcoWyHQf+zMO
         M9Ksz31qsmwnStatnq9+QOsHvO7eJGNnYe+VuXfP/R8RkJrYpU2+ugsQAvLuYgg1C3
         okF+dCU7SaL/rwB2lrA+lka2ClDcPwMcTo8n/T5VxW9m8JpMtd+MOPZzVycGGUXTYt
         j8G7WYd4flJmcmsuyTOBYWwdkU2y/S3u0sv/8ndX9gv0j6MEgr1a5hhdwsJ2oTMRJw
         PRfujgC1M04Dg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9EB13C53BD0; Tue, 27 Jun 2023 02:11:23 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Tue, 27 Jun 2023 02:11:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: bagasdotme@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-EPAAF0t98r@https.bugzilla.kernel.org/>
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

--- Comment #3 from Bagas Sanjaya (bagasdotme@gmail.com) ---
On 6/27/23 08:47, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217599
>=20
> --- Comment #2 from pheidologeton@protonmail.com ---
> I don't understand a bit, since I use a translator. I can attach dmesg as
> files
> from kernel 6.4 and 6.3.9

Sorry, you have to do bisection to help kernel developers fixing your
regression.
Please see Documentation/admin-guide/bug-bisect.rst in kernel sources for
how to do it. And because you need to compile your own kernel during bisect=
ion,
see Documentation/admin-guide/quickly-build-trimmed-linux.rst for compiling
howto.

See you in your bisection report!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
