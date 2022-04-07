Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 041AEC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 07:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiDGHXO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 03:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241849AbiDGHWx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 03:22:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7F749F18
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 00:20:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CB0CB826BA
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 07:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1DA3BC385A5
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 07:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649316052;
        bh=fywqIxrbkARqnaCw2UDY3djZ1ZMy43Ju+LFCnKUCtY0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ewNk1hcdoTypMLb1J1foN/S8Z23MRYA554Z/3ASHGCicQQ2wBmLjzoY/41pG1Agb7
         GJvprE8KgazmvapSMmiLvFsXAJxgfP7FRU0vxCMFTptTx0LbEqh8FuddIrPUSbQM+M
         Bt52pF8oksA/VAvYmjgVsG9Gbn33o9ftrOkE+UiriYs01kc8pkaLuM6oPRsGHsjTip
         EYeZhfympsDvSqGwk2i2uk4knGiBx3N4cafhEmp1yfQChHLqrX3+bj/m0P8buDV6jB
         IiVyZUC+g7b21Ps7+fKaHvvOKJP57tMX9F8yABln/rk+kOcXOJOBEvPviugphBLNzO
         CFrInK6/5rAlw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E79C7C05FD6; Thu,  7 Apr 2022 07:20:51 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Thu, 07 Apr 2022 07:20:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: damien.lemoal@opensource.wdc.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215788-11613-CF96aRcYht@https.bugzilla.kernel.org/>
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

--- Comment #14 from damien.lemoal@opensource.wdc.com ---
+Martin

On 4/7/22 16:10, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215788
>=20
> --- Comment #12 from Jernej Simon=C4=8Di=C4=8D (jernej-bugzilla.kernel@en=
a.si) ---
> Re firmware: both controllers are EOL by manufacturer and are running the
> last
> released firmware (1.49 for ARC-1280ML, 1.51 for ARC-1212).
>=20
> 5.18/discovery seems to work fine (I can see the volume and partitions on
> it).

Martin,

Your series is the solution :)
I have not looked at it yet. I wonder what change you have that solves the
issue ? We should have that subset backported to stable if possible.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
