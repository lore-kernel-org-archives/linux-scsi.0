Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1969C3F6B0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Aug 2022 21:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237710AbiHPVrW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Aug 2022 17:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237713AbiHPVrT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2022 17:47:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF47474B9F
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 14:47:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4498161203
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 21:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99D3AC433D6
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 21:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660686437;
        bh=uV6xkkqFqNCUH+Q+GbIjZuiuZka9pweMBAsfeqjzb2M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=C1Nkn3o2l9FRFdcOCp65L2FFjJJY0z3LeMWtgrb/GEQnay5xJXKvksbogYAj8lEqB
         QZDwZKeecG+r627w25dzzU4MLPPinmS8/yXB0StqMV6NSgHKhJdNKQC4SXbm/G3fh/
         dugCZZM12T8qPds8VCtp2vHe5We6oHiqlYYSZVwGuGTI6hYvixzI/bLcHfhbi9tDH0
         VxSeAHyGOzUS4vbJQs3eYrT0A/pFpXI5Q28Nw8rbsqI7fY00vrxNjfvE4qE2SgU5qy
         gbUA8YWW8VkPC80fNR+0M0w79tJvKZLc6xPUqd6ByjMjXnjtGdO1pcylQFirP1Lwoh
         ceGlq7jqq1qFA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 81755C433EA; Tue, 16 Aug 2022 21:47:17 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215943] UBSAN: array-index-out-of-bounds in
 drivers/scsi/megaraid/megaraid_sas_fp.c:103:32
Date:   Tue, 16 Aug 2022 21:47:17 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: gustavo@embeddedor.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215943-11613-T9RqPFZqB6@https.bugzilla.kernel.org/>
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

gustavo@embeddedor.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |gustavo@embeddedor.com

--- Comment #7 from gustavo@embeddedor.com ---
V3 and, hopefully, the final one. :)=20

https://lore.kernel.org/linux-hardening/cover.1660592640.git.gustavoars@ker=
nel.org/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
