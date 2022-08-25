Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B3D4ECAAA3
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Aug 2022 21:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242072AbiHYV1b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Aug 2022 17:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbiHYV1a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2022 17:27:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6EEB9FB2
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 14:27:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8239B82E96
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 21:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64B78C43470
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 21:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661462847;
        bh=1reNfzHuHsDIUGx5DfAxjr5GQW9UAR24CP8bdRUDSj4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Mec/6vMkxk4bzWTjevcCM0o4MZe6tI7ROkp8KrzxTvyKLAJuolHJ6QfJYDI7Bt4TM
         0Nqj0XhFgTsisOv/mCakpvjxqtGz7pO7eyvkif6tSkK96FwRFRYmURsApKvTtLglC2
         HmJXwaA1G2Ya2T77X8z3LMiOhw+JsiW47Qe47Ww3OKjHasYtS8drLOphns/88oqWx3
         1t7rxU5EScSaKUniG7Fc6VCxMnzo5SHJVTi3dqIzQY92S83kk1Uq/eBHGXeDs7Gr7E
         8wNrCCfEMo2lcdT0S9R4gjOqRECSDZG0hQ0j5HutLQPXUEECYF1jzmE2am1syEHQwJ
         B3/rs6MIfdxog==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 53EC2C433EA; Thu, 25 Aug 2022 21:27:27 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216413] [BISECT INCLUDED] scsi/sd Rework asynchronous resume
 support breaks S2idle and S3 on several systems
Date:   Thu, 25 Aug 2022 21:27:26 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: bvanassche@acm.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: bvanassche@acm.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216413-11613-p2Or14S4UC@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216413-11613@https.bugzilla.kernel.org/>
References: <bug-216413-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216413

--- Comment #1 from Bart Van Assche (bvanassche@acm.org) ---
A revert for that patch has been posted:
https://lore.kernel.org/linux-scsi/20220816172638.538734-1-bvanassche@acm.o=
rg/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.=
