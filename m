Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DAE250E5
	for <linux-scsi@vger.kernel.org>; Fri, 15 Dec 2023 10:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZM86oVHT"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A909EC433C9
	for <linux-scsi@vger.kernel.org>; Fri, 15 Dec 2023 10:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702637504;
	bh=i0u9T+5eidEBMEtUfYwLCGacprmg+kqZ/xYnjT9buRc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZM86oVHTEYOVDpmKbjb8WwGHRMNt6x2F5UuRWU/6xtXsPM3Tmu7tQeb5GA7yDzF1m
	 jl8vH6hdnYPbq5T4axzh26EngsyntfY3XO/DdTRF+B2S/fffeBuOTju839eRTvydLo
	 KrCg2yZ2vTKQ8WlBdNAYD/IMXCHNC1hi2H518uwRzEKmXFHb0s9q2RSEZhZ3cvxcw4
	 /vD1BswbYmhLGlqn3r4H3KfFiE4n9DL+BRWlaZZN+rqCHxvNGLAg7spblkddNp8g8h
	 fx89/bewab74AnWHGM0mLcBK+dDKpT+TXIHFkL2R2oyr5lJBXN6qC+zuUGPTVoV4Ej
	 9rDEvQg986xGg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 95460C53BC6; Fri, 15 Dec 2023 10:51:44 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Fri, 15 Dec 2023 10:51:44 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: regressions@leemhuis.info
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218198-11613-pr8dfVUSpN@https.bugzilla.kernel.org/>
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

The Linux kernel's regression tracker (Thorsten Leemhuis) (regressions@leem=
huis.info) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |regressions@leemhuis.info

--- Comment #17 from The Linux kernel's regression tracker (Thorsten Leemhu=
is) (regressions@leemhuis.info) ---
What's the status of this? I have this in my list of tracked regressions an=
d it
seems nothing happened for about a week -- but I might have missed somethin=
g?

Or is this not considered a regression for some good reason?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
