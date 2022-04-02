Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBDDDC433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Apr 2022 07:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238966AbiDBH62 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Apr 2022 03:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbiDBH62 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2022 03:58:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5451B9FE9
        for <linux-scsi@vger.kernel.org>; Sat,  2 Apr 2022 00:56:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D070A6106D
        for <linux-scsi@vger.kernel.org>; Sat,  2 Apr 2022 07:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35865C340EE
        for <linux-scsi@vger.kernel.org>; Sat,  2 Apr 2022 07:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648886196;
        bh=4mD8LPmZToeKy3ikB2aRTPYfABQ68yI2b3WznHf5Dy8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hIcKUeVQ7pMeYJ+V60KlBZ5OAGQhksSZT+yEVDzdI9IMFfX2loBiqHOwTYnz6lp5m
         nyCXfnwnpIOUCFQg6PriA4vqsjtlXGbICqxpA3LZGuVzacMjG3994eI9r1xA02c0Ae
         Q8oq5Etg8WkhsxkEKcsSWXIRRKMmaMjQZ7CArTKy1XbBc6ZYLvJUF7kY9Aj8Jzb6Os
         1QZHrRCUFAcQVWl82JCImhfXf4MH0KGwulIx/LE/DCtzWQgX8ekHD1jkU3nlR8cdGB
         MY1yuMnlm9R7a6Gcnneu4TVLlUxEpUmqtqvQNw+dspCY1dezF2tTspggXJMMFcrBXz
         3fEMbkzOmUeCw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 1E333C05FD2; Sat,  2 Apr 2022 07:56:36 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Sat, 02 Apr 2022 07:56:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jernej-bugzilla.kernel@ena.si
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215788-11613-hD9SNB9Cbr@https.bugzilla.kernel.org/>
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

--- Comment #1 from Jernej Simon&#269;i&#269; (jernej-bugzilla.kernel@ena.s=
i) ---
I just tested on another computer with ARC-1212 controller, same problem th=
ere.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
