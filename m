Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F3EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 07:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241664AbiDGHUX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 03:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234490AbiDGHUV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 03:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE117086A
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 00:18:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD54861DED
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 07:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0E1C5C385A5
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 07:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649315901;
        bh=9HQGhqoKyzog1svmNuTqdC2UoVXOp530od9VEvR8qlE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Fhc2ZHGOuPB71xrWOGakMfaM5YVUuBPEULxVoBq2nkReZR5mZmjqEBL2k5Gfuyk5D
         bq51alLCgjy1H95lsRIZQcIKvBhIxL6NDRL/Q964ZS7Kp8FoXKXkN0HvCbGoJ6F8X1
         P8iJe0/yUoedyqQeMxrLnEDSD8xcGTUWnD8NP0mo3abuRyEyXlrl/7pLJ6VIARgMxl
         1L79SBKjPhchuxwLsrAesfsiapFFN24PHmqZz9U0wGn9m2eqr/wNH5bKGbOqJ8Ws7B
         +u/s86Bw8pRk4xgiBwUMvg8RQN1D/X8nUHnyOc40O/6zs+IZgFBAvHNJ6C+HAkcKHc
         s1e2ay0IR0yLw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D4E6AC05FCE; Thu,  7 Apr 2022 07:18:20 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Thu, 07 Apr 2022 07:18:20 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215788-11613-Rb7rassFRS@https.bugzilla.kernel.org/>
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

--- Comment #13 from Damien Le Moal (damien.lemoal@wdc.com) ---
That is great news ! So now we need to figure out which change in there avo=
ids
the problem (for backporting to stable). We will sort this out.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
