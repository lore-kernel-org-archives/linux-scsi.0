Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 411BEC4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 19:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E594613CD
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 19:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhHWTUD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 15:20:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231530AbhHWTT6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 15:19:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 76FA461357
        for <linux-scsi@vger.kernel.org>; Mon, 23 Aug 2021 19:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629746355;
        bh=+9lAd0MxXbi4mGw55eFPwmo/8WBJY11dtknTO5bu2fs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=oBHLl/Dpcpf/udgL9jiRKk+4x4Ksf1ka1KKBMEqYxLzRmi5HrKuh6Da4G9+IWhDww
         477oNJ5EppsBbRTBdPAPdOieXnYFi0dA+DvjIyfU0h75/11iW4DLN3GGhLBwUbBauq
         WZKhwB8p2kgbVN+wTB6+ppd0x6wg1VYMQNCbWFwbRuZtzGsghiRhR70dBSg++3+5bc
         sFpV1nb+11EaZhqWK1xLfkmVBBh7iF4LUndHXUqHfIhymrjgd8dQf/YA8jCCC9xXgB
         IKvOLi5pUqvpobdagf6jglbCf3cAqdJt7CChms8UmYx1R0L70rZJWanFskKik005+Y
         oaB48aR8DJXMg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214147] ISCSI broken in last release
Date:   Mon, 23 Aug 2021 19:19:15 +0000
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
Message-ID: <bug-214147-11613-bwqmsrKpjs@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214147-11613@https.bugzilla.kernel.org/>
References: <bug-214147-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214147

--- Comment #1 from Badalian Slava (slavon.net@gmail.com) ---
5.13.4-1.el8.x86_64 also have this bug.
5.12 work ok

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
