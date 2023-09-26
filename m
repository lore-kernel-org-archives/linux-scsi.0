Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8EEDE7D245
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 07:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbjIZHgY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 03:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbjIZHgY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 03:36:24 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8A4DC
        for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2023 00:36:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7FEDC433CA
        for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2023 07:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695713777;
        bh=ke/2TIMEfbz9/MBV4W7S4weKK8tajjAz48nfOUfnmco=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=bkR6UHJEEBK2J6z0OM94srj07zNF23DENvhTBjx1rXN3J3FZb1zK4QRz+rzS8OoYr
         6oanEY76W2/gGOm2SQX1blhXoArdgfNKMgZ82276BV/NdQ2tISh1W/UwRaawn5xF9t
         yopB3B5ktqbssflADIVFC3BqnlWUwuMG2Vc5MMvu2bu2AipNqAvgk24F1iIcf9d/EF
         edStiLmavN4Wv9GuWqz3TOP1/O1MxEzNAsvCsBAKYQbNeRBVzYHUQYeQ7LBpgWuW5r
         hqp+T36xc5J/Hq1/6IS8sDWkHBHJqm7t1JHssAd9adV6GWoj8VtDoKlFbkrRFrMp4M
         xzidgP1oMUFuQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id BE8EBC53BC6; Tue, 26 Sep 2023 07:36:17 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Tue, 26 Sep 2023 07:36:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: info@webix.ws
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-Yr2lO5LwkJ@https.bugzilla.kernel.org/>
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

--- Comment #20 from sanic (info@webix.ws) ---
Hello!

I can confirm this behavior with 6.1.53-gentoo-r1 kernel. My previous kernel
6.1.46-gentoo working ok. Patch mentioned in comment #13 has been applied in
6.1.53-gentoo release. Controller Adaptec ASR71605E with 7.5-0 (32118) firm=
ware
(latest). I will try to revert this patch and provide results.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
