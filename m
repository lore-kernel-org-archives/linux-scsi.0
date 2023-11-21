Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A070E3C077
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2023 09:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AaV7W03n"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2AAFDC433CB
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2023 09:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700560444;
	bh=IUyVI8Ex/SwYvsSrWitKiJ7mJX5YemxjBRlGqDrA4tc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=AaV7W03nqD6HRI5d81MCZhNNoVz/J/5bsSUjmYMXhBesz53TF0FqprqBYAqLGaWaj
	 RzizrGiCIEjbEFBHRE2syskPonZD70Kl7PyxnN/Ib4QVYCyIR7aaIGzpbJJr9IiDUZ
	 cMVIzs5CwtlwzKfjqM1VHlurpA7fYOB2Vz7Hc4kTUNGl+R3ti7b5+xFNdLXzvRo/YL
	 d6pOlvFYVuSZ/aqm8vl8rCRwTChPQlnpv6Hfpfwl+DPCrA4iO6Iqk298DuiUsSR9HS
	 J+ZJL81dNl8TZb7kN8071SDE55k1vw2YvFIvgSgX8gTyEn9uNXHCZ6YR5LA3NY58hF
	 oUI4szDTkE+uQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1719FC53BD6; Tue, 21 Nov 2023 09:54:04 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Tue, 21 Nov 2023 09:54:03 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: regressions@leemhuis.info
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-KqMMkRHrKc@https.bugzilla.kernel.org/>
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

--- Comment #29 from The Linux kernel's regression tracker (Thorsten Leemhu=
is) (regressions@leemhuis.info) ---
TWIMC, I raised the issue once more in a mail to the people that should han=
dle
this:
https://lore.kernel.org/regressions/c6ff53dc-a001-48ee-8559-b69be8e4db81@le=
emhuis.info/T/#u

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
