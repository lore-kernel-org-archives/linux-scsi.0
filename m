Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C09AC15B
	for <linux-scsi@vger.kernel.org>; Mon,  4 Dec 2023 09:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u68Q91Ew"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 417F2C433C9
	for <linux-scsi@vger.kernel.org>; Mon,  4 Dec 2023 09:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701682296;
	bh=euNi+3tiOiFS1FjOSjYhCJakZcOSx0ua0LF1yM+Aws4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=u68Q91EwBYl8EA3xMPcyGccLrjCvyYGRGTl42O8U++df7pmAECVmHMfCmdnfgO2vE
	 p+HQQ0MGloEgU6LwEGQXFY7cjKuRM2m7kedLareUjsvwsbKj1WB8qpGiLAqAaGHVw7
	 dWo1eAxEaCBWsywsJEHd2PdbmGGsHcHEBG12WKSDGdrwbHgsR0eKjt6LTpuARcscrN
	 cmnDF1hnYkcRJqtQjMF4DtIjrKdoF5eT4a0KBgdyRC5JtA6a/wNoazKvMY3+AQYMSw
	 uBlAvZSCrNGQtB54JloxMKZzpiLpS/Seo1QBfoIpFVer1Qlco0frUsU3MXY9gJ08Uc
	 grOiHhIXzjS9g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 29D22C53BD0; Mon,  4 Dec 2023 09:31:36 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Mon, 04 Dec 2023 09:31:35 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218198-11613-Bo6VtC0lyT@https.bugzilla.kernel.org/>
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

--- Comment #13 from Dieter Mummenschanz (dmummenschanz@web.de) ---
Maybe it helps to mention that if I issue=20

hdparm -Y /dev/sda && hdparm -Y /dev/sdb

a couple of seconds after successful resume my system transitions down to p=
c8.
hdparm manual doesn't explicitly tell what command is issued with the -Y
switch.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
