Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B1318CC13
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 07:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754897901; cv=none; b=hss+xk1AeQ6qxwSdooKAIEEf5XPU1Ga7B0m8mpV+2YOVYsDcStrYzF6+azuj+BLxB+7B3B6JrMl10HHWVWaan/t+HPX+AgTiOCOAEwg0GjjCzbtWW6cuEq5JPFcniINjsY4odibXcRfAzYI3dr5nKV1Higj1JgXHc01LAjDWexQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754897901; c=relaxed/simple;
	bh=VB2caF/AoAPUsl0LYN5WijbkstQQx095MomTCO6LIDM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OU99Zo5Qsgx7ELCXxXDmESfxDqc2ut/0dh2342POoikqji0fxjsIq+2lSwVk0exdeZcPZLv9QBqCecZPCJBYlcXnPGs5SFn4fkT6nWbGDboFZHRLHGLesNI6FVKUxJsrIdSquVZyGVq4QoaY3I+Ig11XFC438lCGhKocqjDIZno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iyxnJGyV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iyxnJGyV"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4487CC4CEF1
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 07:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754897901;
	bh=VB2caF/AoAPUsl0LYN5WijbkstQQx095MomTCO6LIDM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=iyxnJGyVye14rrZRMnXWC0bYAx/XCXS62WFPfmsmmxns8D+YHflqTbPQEaFjRiaiU
	 WVyIGJ8Ue+kxExpf5dewBXGdTbibfQeixR2TCHjcyBB9lv2LcbLPXeGr/gr1+vs7f+
	 TZ626hOLcc1u/UejqEd/8zlCP7xvRCTZuO0k53qM3syqnmnfsaFtY6wk/bTpI65au4
	 +VMWsxEOFrJef7cIEP73ENftwGmOzPMiKVozuH6LibsVX7O901QRER40edcAnPXPkf
	 mkM3gxflqxHvWeP3djr5f9+Y+4/b2kcJnBjyVBqRdTGPhBewm2o4DONeEs7X34E0/w
	 jcWufzgEQiBgQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3E7F5C53BBF; Mon, 11 Aug 2025 07:38:21 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date: Mon, 11 Aug 2025 07:38:20 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: besepo7268@cotasen.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-213759-11613-LiS2SX1n7b@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213759-11613@https.bugzilla.kernel.org/>
References: <bug-213759-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D213759

besepo7268@cotasen.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |besepo7268@cotasen.com

--- Comment #21 from besepo7268@cotasen.com ---
Car wheels are circular components that enable a vehicle to move by rotatin=
g on
an axle.
https://wheelles.com/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
