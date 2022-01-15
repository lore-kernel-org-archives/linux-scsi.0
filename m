Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8F8C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Jan 2022 12:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiAOMRD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 Jan 2022 07:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiAOMRD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Jan 2022 07:17:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1578DC061574
        for <linux-scsi@vger.kernel.org>; Sat, 15 Jan 2022 04:17:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1D0260C68
        for <linux-scsi@vger.kernel.org>; Sat, 15 Jan 2022 12:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0FA2CC36AE3
        for <linux-scsi@vger.kernel.org>; Sat, 15 Jan 2022 12:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642249022;
        bh=YX/ZovxHmklrNwCllpp4DAuubgxe3u5fhfsp4CdznUU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=g1KzKMs8h6ta3sSXE4NY1xMa8caq9ch3tKf6Ww+84diiCgnKLb0S3GpRPnVQ5RZ/B
         KRiwQw+LXIp4bK0JiEH6lP9vWRFK0BE8eUuhylByC4ZOQYPL3UGl1FLwNSCm5mK2dm
         ybdEeqPTAAs/QGE382v1zpefyjEacQjWRGYO5x7pMX53taLZvdIFebNDeQo/kGfz+L
         zOfoiE6nBYXKL8LZ0y4A0S/2t2tc/6oU5qIGEWLgE558u68uBEuXxudipBAveFK7md
         H1OoOpFEiE0XtEXDtNxRawdnmV8pG72PqHSHg5aOaqaVU8nOhcofFhGrFsCmGtw7Yv
         ZjQgD3vuoWM6w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id EADE2CC13AF; Sat, 15 Jan 2022 12:17:01 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215447] sr_mod scsi_mode_sense() failure -> "scsi-1 drive"
Date:   Sat, 15 Jan 2022 12:17:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: cshorler@googlemail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215447-11613-XWY1I1HHBY@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215447-11613@https.bugzilla.kernel.org/>
References: <bug-215447-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215447

--- Comment #5 from Chris Horler (cshorler@googlemail.com) ---
Is anyone able to comment on the sr_mod / cdrom / mptsas issue I'm
experiencing (see details in bug)?
I fixed my issue with a one line patch, but I'd like to know if it's
correct and what I should do to have it integrated upstream.

Thanks, Chris

On Sat, 15 Jan 2022 at 11:42, <bugzilla-daemon@bugzilla.kernel.org> wrote:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215447
>
> --- Comment #4 from Chris Horler (cshorler@googlemail.com) ---
> self-ping my list-email
>
> --
> You may reply to this email to add a comment.
>
> You are receiving this mail because:
> You are watching the assignee of the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
