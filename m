Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B8C0C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 22:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357597AbiASWsV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jan 2022 17:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiASWsS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jan 2022 17:48:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B71C061574
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 14:48:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2C94614AA
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 22:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CFC3C340E9
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 22:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642632497;
        bh=AHArSgjzuLD2yQeU1mPQQsii9BMMGIQ/FEe9+ovzR3w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Zuo+MyYPHsd2hyp1eKbSLbi4Mvj/G+/44drWPJdTH//G9yrwEQZpQx+jjyVw9NTE2
         zZcLrlDCO0d6RIp6wlhs/mzmLiVQ2OyxPZxpXC3kWuLMCtDe/YJMU9ITfQ3+ajy/H2
         Do/POov/SBWGSoEdB+UtIcUV/LuNDSCQpHy//lhqqe+Bn1QUGNkok5eZYI3j4wOrL9
         1SU8vUeFSLhYTWTB9miHtQVn0kf/Yxe3RLRLRjZCQhVYI0OU86rrag58ln2Igl70e4
         7mZLDEaSEY6ttmy0j+BqcZNT4g4nsPEjiFeMcXPD7MzyM6bdy2a7UT1fjWq+LZTPXi
         Nh5VKzTPWhEIQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 43311CC13B3; Wed, 19 Jan 2022 22:48:17 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215353] VMWare LVM partitions not recognized, sees base disk,
 fails to Boot
Date:   Wed, 19 Jan 2022 22:48:16 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-dc395x@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: richr410@yahoo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-dc395x@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215353-11613-JV7vEpw3NN@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215353-11613@https.bugzilla.kernel.org/>
References: <bug-215353-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215353

--- Comment #6 from Rich Reamer (richr410@yahoo.com) ---
wow thanks - I will pull one down (after confirming the 142c779d05d1 buildi=
n)
and test!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
