Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24B815AEA
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 08:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y5J8jBSq"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3733CC433C8
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 08:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701159875;
	bh=oLnWLt3eHO9oSvLWSmaQ7xi56fdg1WdFuXSPHJxp2ow=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Y5J8jBSqK2nu0LDKdVcwk7qMUmJuyZ5YGgOl9Sp8gQGA/5fwZsRS3pK9u8ZQPNNGE
	 MByV0KlaDcb097eFBWyfc8qsEY+Y3Lfm8cFa7YKrhcbbUuwJhwhsBmGWOwr/VgckhR
	 U5ugLgpU5b140A4QaDPq5go0BciQWLafHzpYwFAsNAVC+fJj3cjo+fug2b+yUmV25c
	 sugui3jCyzlfJmesAviZB2tTY4NQmIEDNLCBE84Y4VuE7DngRcwXSMJiTmIz+HyBDL
	 O7tPWdmvQqca7T7l9WaoOjW9iMgZ8EZd1s8kNdBBzmNlgp1iIwi4ICbyxFHsRe4vqw
	 rf8ceL9VbmFlw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 273D7C53BCD; Tue, 28 Nov 2023 08:24:35 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Tue, 28 Nov 2023 08:24:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: dmummenschanz@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-218198-11613-Yp6xKA30wT@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218198-11613@https.bugzilla.kernel.org/>
References: <bug-218198-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218198

--- Comment #3 from Dieter Mummenschanz (dmummenschanz@web.de) ---
Created attachment 305490
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305490&action=3Dedit
dmesg partial log

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
