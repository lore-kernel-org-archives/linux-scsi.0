Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B8EC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Mar 2022 09:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbiC0JuV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Mar 2022 05:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiC0JuU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Mar 2022 05:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2091FA67
        for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2022 02:48:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F5C4B80BEC
        for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2022 09:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2B83EC340F3
        for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2022 09:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648374517;
        bh=U7WGoXHC4DJV/tqJp74V126U1wDUHqbYoT/6n9CncTQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=AGt7pq3P8rQqwlsHURM8IJ8Pu4u/rx9hagagfp3fDVWIeWI8OHXaKpFRN7ldHABCu
         QI8uPd8YpKr2hQLYsqirlNCwUmSvv+5GobdiFhc77TYfiY5U6IRx5GrGTknaml171p
         dQE4pHv0mae0N4nvcD3qFp6U8+nmkDVUImaoSSesKH/a+BP8WbQ0rEP20qtiB8gxvo
         Cq2svPZCTU3uByl5O22CBrVDGN0t5bTr3FMsm0079kanOTTicR/oVRMqeDIQk/qKQV
         qWnV1xzjXXqLA3/gph53XnsXut90643vTwjo+WvPoYCne8RsonUsXQY+kCot4zpm1f
         8LCPokDiza9SA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0952BC05FD6; Sun, 27 Mar 2022 09:48:37 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215691] mpt3sas "SMP command sent to the expander has timed
 out" cause halt
Date:   Sun, 27 Mar 2022 09:48:36 +0000
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
Message-ID: <bug-215691-11613-WqW4k3Hvj4@https.bugzilla.kernel.org/>
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

--- Comment #5 from Badalian Slava (slavon.net@gmail.com) ---
https://support.oracle.com/knowledge/Sun%20Microsystems/2667269_1.html

looks like same

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
