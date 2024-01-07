Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD0E12B84
	for <linux-scsi@vger.kernel.org>; Sun,  7 Jan 2024 10:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q/cgkN6V"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C1F1C433AD
	for <linux-scsi@vger.kernel.org>; Sun,  7 Jan 2024 10:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704622303;
	bh=H9KXHTo7bFBHFjFmWVtjAexXYZsF1M8v/1tm9CZ6tXI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=q/cgkN6VipL5da93iFWz7+4qCAerMbXjoitivkC8QQ9AvOHxs0JkidgpEAQ6INSNC
	 GVutWNnkNritbHyXbfiS56NN4fVqhgaRjZckaJW9fRapTDYBxK195lFvk1hpUBr97E
	 4+L1W4eBp+lUaPD9Y9O9gs6ygG3JIBw4KvfBMPlDIEttqMm0fhrkhu30rrbXmMS6e+
	 MnkZPaLvAzdosA3axipBqifnIC0//3Z3mWp4Eb6VdvcBqHUOMuhOvtUSLuKnnNq08r
	 Id5gQMDb3KU5kVPHd4sBllc3eIo95k/zvMccuxEu37UlEY9GEygGITj8wykvpniFrP
	 3SOFxKGMU4Rww==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3987EC53BD2; Sun,  7 Jan 2024 10:11:43 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Sun, 07 Jan 2024 10:11:42 +0000
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
Message-ID: <bug-217599-11613-WzL1PqCWUA@https.bugzilla.kernel.org/>
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

--- Comment #57 from The Linux kernel's regression tracker (Thorsten Leemhu=
is) (regressions@leemhuis.info) ---
(In reply to Salvatore Bonaccorso from comment #56)
> #regzbot fixed-by: [=E2=80=A6]

Thx, but this confused regzbot a bit, as it tracks the issue as a mainline
commit only this is needed:

#regzbot fixed-by: c5becf57dd56

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
