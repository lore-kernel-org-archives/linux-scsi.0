Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42C9C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 13:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A90D64ED2
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 13:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbhBSNon (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Feb 2021 08:44:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:52392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229636AbhBSNom (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Feb 2021 08:44:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8C6B264ED9
        for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2021 13:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613742241;
        bh=mllhzSCd6VgQ73yxLDowRrtmUwPxw50NElt0RmBLgNQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=H1A8uvL6j+GWWrB7+J3AMJ4+aTDuFM8XBJRGz0JL16gnEsx4CwJ5GIRiGMfbAMvij
         KYvolChpwWj0NVJnNm24FJ6CiF0MKt7C0Vl6/ElidN+h5Vtp67efEaZ1CAFsWJvcaE
         VCtHs/HJH0Gs6bGCXNoTbq6wbOwpntfhVJ18V/cXV5kCWUnIl0LukDFQalO+n0RQrH
         VZ85XzCM12xkUvzmRRYbOt+a/rid2MG/CSb8wYTZWphHxd+eVW/5PGSkh6aGUf1e8u
         YzJsPBkVCv3zFmHN6JD7Kvn7vxmti2ouS+fh9b/7AAKE+zZBusl7yC5Bkz41UeSw+y
         9yNpr4iwGVN/Q==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 211227] [BISECTED][REGRESSION] Linux 5.10.7 breaks s3 resume on
 opal encrypted ssd
Date:   Fri, 19 Feb 2021 13:44:01 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: axboe@kernel.dk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: component assigned_to
Message-ID: <bug-211227-11613-FTa8oQoPTd@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211227-11613@https.bugzilla.kernel.org/>
References: <bug-211227-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211227

Jens Axboe (axboe@kernel.dk) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|Block Layer                 |SCSI
           Assignee|axboe@kernel.dk             |linux-scsi@vger.kernel.org

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
