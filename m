Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1345817E
	for <linux-scsi@vger.kernel.org>; Sat, 30 Dec 2023 00:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="szOQFGVu"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2990DC4339A
	for <linux-scsi@vger.kernel.org>; Sat, 30 Dec 2023 00:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703895722;
	bh=MTu2zyIU3DOdSEC0gzsGTx+2dfM0bEw4yPwDOExVAjw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=szOQFGVu3KXfZ77dUD7YK/s9+zMZWT6TbsnU67cVKcIurwQoC8+nxeeKXaU/a6/8V
	 EuSsUv3W4YXYIeV7L+fBfSod92NHOTbU9xgootBUzkpT1IGxedltWHO8u9tfMsUmaN
	 sdm6oCa/6JirmxWqPB0HBwUea+UCqsrB8f2hnoikBxs2WKSkVKLujHu6xUL3UI0NAk
	 wOvcSaFjJ8wB0RB3ZnescY/K8uHtnN76aRsdyphNiYMFfIF9B69VWEVBN0VdGYaFxM
	 Eo9vpLYcsM+Ux4S22EdLvFXbXqY0PjiNNlKtuhpGeIQqVBqoeR+9RyRfe1KNyJu3Sb
	 9SCizFtFaCf9A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 19F02C4332E; Sat, 30 Dec 2023 00:22:02 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Sat, 30 Dec 2023 00:22:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: samuelwolf85@googlemail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-BhkSHpcbDi@https.bugzilla.kernel.org/>
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

Samuel Wolf (samuelwolf85@googlemail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |samuelwolf85@googlemail.com

--- Comment #54 from Samuel Wolf (samuelwolf85@googlemail.com) ---
We are also affected by this issue on Debian 12 machines.

Adaptec ASR8805

BIOS                                     : 7.18-0 (33556)
Firmware                                 : 7.18-0 (33556)
Driver                                   : 1.2-1 (50983)
Boot Flash                               : 7.18-0 (33556)

See also Debian bug report:
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1059624

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
