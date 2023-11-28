Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2544584FB
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 14:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EpZE3+wl"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E546C4339A
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 14:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701180954;
	bh=CLdYW5YbXx5GqcX0M04FyzfxoPFyYXk0Auy/M53Y5vQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=EpZE3+wl+5PdZY4sBoigM7i2YsR1DjiTZ+YYTEPuI/qQ9TqcYov3iQepu/rWrWZ5K
	 l3nVB2+3YqwvaEpA59LEdlY1NaV0M5S10Y4QW/1U26FVCrCT6/lnGoSsQ8Y2/1sHgG
	 1LnDRCySw9juFJoc/DyVKPDzjTV8od5qvM8sjdAYT3f/0tIQVDnePrzK/b2UbNhyxV
	 xOtS55Uq1MTmchrBhESDmA4OKKLh+6ODKt7gFgqiI3jqc5+q7sxi9BEwK6OI3DlbOD
	 A5gjA+5nyAlSYKgOi8ggTRhM87daHZpw+76V4yvqPUNYchjAOntM+H5kDE9i/fA8nl
	 FO6f2Waf6XUuQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 4E64BC53BD4; Tue, 28 Nov 2023 14:15:54 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Tue, 28 Nov 2023 14:15:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: f.gruenbichler@proxmox.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-rpwkRsAMVq@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

Fabian Gr=C3=BCnbichler (f.gruenbichler@proxmox.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |f.gruenbichler@proxmox.com

--- Comment #42 from Fabian Gr=C3=BCnbichler (f.gruenbichler@proxmox.com) -=
--
while testing the proposed patch
0001-aacraid-fix-vector-calculation-when-submitting-command.patch I also ran
into the system not booting - this is even the case for systems not using
aacraid at all ;) I tested with 6.5 based on Ubuntu's kernel, which is also
affected (the VM in question was actually running Proxmox VE 8.1, since tha=
t is
also affected: https://bugzilla.proxmox.com/show_bug.cgi?id=3D5077 )

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
