Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EBEAC61DA4
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Feb 2023 01:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbjBWBwN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Feb 2023 20:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbjBWBwM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2023 20:52:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BB8A3
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2023 17:52:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A14E3615C5
        for <linux-scsi@vger.kernel.org>; Thu, 23 Feb 2023 01:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18EB5C4339B
        for <linux-scsi@vger.kernel.org>; Thu, 23 Feb 2023 01:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677117131;
        bh=pIj0eUeIKGXXOD93v8lJ1HwzIX9CuAsIxT6o/kBM5cU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=qPWL0jTzLBHbYYbbXEPm8hjH5bEsu4yzCVlQowG5M6JDE3CYnflfwvZw76jiWh1nf
         u3Gxjg5dmjbTvdXkBYYjkDJjSiWTbRrJyTFKYJqOdhZTb2xMXQjZ9/ZOWcLxBoIy2I
         uXbvyed9FAidw2XvGenZJp1b2Wn6EXgwRWbiT1PCt28nv/wpDoBr83mFXWgzOblt4R
         UB8RADmmdezYcuu8QRV4f62k2KVHj1M6/p9NgYxA2JFujCeEKjox8Vg4viUe6gtAxg
         3T0g4KEVoyz5DgN2ELyD+vlJTUfJPBqcBOmwPgFs1ZeF9coZlK6+6ovG3VO8+zokM2
         MQCKzjVO7rnqQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id F0759C43143; Thu, 23 Feb 2023 01:52:10 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215691] mpt3sas "SMP command sent to the expander has timed
 out" cause halt
Date:   Thu, 23 Feb 2023 01:52:10 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: slavon.net@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215691-11613-yTTOTZifxu@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215691-11613@https.bugzilla.kernel.org/>
References: <bug-215691-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215691

--- Comment #8 from Badalian Slava (slavon.net@gmail.com) ---
Info and may be fix

https://www.truenas.com/community/resources/lsi-9300-xx-firmware-update.145/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
