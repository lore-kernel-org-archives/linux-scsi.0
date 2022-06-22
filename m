Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 868E2C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jun 2022 22:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357635AbiFVW1Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jun 2022 18:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357800AbiFVW1Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2022 18:27:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2D13D1ED
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2022 15:27:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8798D61A0D
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2022 22:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1546C341C0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2022 22:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655936843;
        bh=mi6J18vRB/ABwl75gjvaU/rTegXjbad0uTb9CmMkMXI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=r0K6SIIr621youPkBO/Tbbn6iNu4c28EX4u46LHgG0Temoy/e9OKuIAf9LJKGP31X
         B5bbh5NWWEwwNXCdpB4FQ2FNpEORqmFB/gzpfEVslBVw7j6TTE5u9p+F/M2kYrae18
         EjiVDhDpQpj8rVzYV03Zm8f/P8CuN1jNSvTPE70zUxuuoxt6X+rWNNczknC6ntYYZT
         LWPmXegrEfLUFTgQ7bNwCQwB3q2ukihJ3Rbct2H3k3jkId+Pk0QRHxlHSJDV2dYPAK
         3j87hIRIRc/leOI9rTj/jrfglR+blK+zqQ8b+28UYx9uxZOjBKxUIqxmSICTTeSX/m
         3b1zhht9N1x7A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D945EC05FD2; Wed, 22 Jun 2022 22:27:22 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215943] UBSAN: array-index-out-of-bounds in
 drivers/scsi/megaraid/megaraid_sas_fp.c:103:32
Date:   Wed, 22 Jun 2022 22:27:22 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kees@outflux.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215943-11613-rXpNm9TChK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215943-11613@https.bugzilla.kernel.org/>
References: <bug-215943-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215943

Kees Cook (kees@outflux.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kees@outflux.net

--- Comment #6 from Kees Cook (kees@outflux.net) ---
See:
https://lore.kernel.org/lkml/cover.1628136510.git.gustavoars@kernel.org

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
