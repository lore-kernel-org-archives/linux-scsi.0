Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D6FC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Mar 2022 07:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbiC0HdU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Mar 2022 03:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbiC0HdT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Mar 2022 03:33:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4D0312
        for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2022 00:31:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAFA7B80BAA
        for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2022 07:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 917D2C340ED
        for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2022 07:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648366299;
        bh=67hCfXw6+pc91hz1mUXcyx/jVGSALcHCJql0kcBwCnw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JQ/d1bZgXXMLL9GA8bt5iJsA53KLS6uHE9UvlPw6ixGWmIf1KtUL3am4Lhk37VGTv
         R9gwSQOCCPo33uiBgacZbMW7gbHwilkwQnVrXoBUJYRRK+mWBjbM+c/iKUU8a06N/D
         D5mBLye/RYTwc1oX0AZ0bAn7NTKBFLrRXkts6w2d6+7i3jXZ12GlC40BFEqR4DTN8e
         fRd/gZcu+3X+QNj+I7qgN40LMJ0V8kSQytXMHVqj8KUx4cGOYt/6IuRm+5oCus0FFl
         9NNbZtwAdHdpaJSIVy2EC/qGNU990fMXn8w0jx4jOAAm81zzT9YkO+WiqCoa1XTWiA
         aYLW6cXTg8jrQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6FF29C05FD6; Sun, 27 Mar 2022 07:31:39 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215691] mpt3sas "SMP command sent to the expander has timed
 out" cause halt
Date:   Sun, 27 Mar 2022 07:31:38 +0000
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
Message-ID: <bug-215691-11613-lVmTMZ49iQ@https.bugzilla.kernel.org/>
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

--- Comment #4 from Badalian Slava (slavon.net@gmail.com) ---
Added another crashs added. Last try on 5.16.16. Rollback to 5.15.4 - few d=
ays
work ok

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
