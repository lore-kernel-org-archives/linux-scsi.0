Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B9312B8D
	for <linux-scsi@vger.kernel.org>; Sun,  7 Jan 2024 10:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AA33urKP"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92941C433AB
	for <linux-scsi@vger.kernel.org>; Sun,  7 Jan 2024 10:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704624489;
	bh=nU/zZuzq/S8kw1V8Q1LLf2p1n6Gj2Tq0szjNN78WVCU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=AA33urKPgla2KC5b87ekVWsat0ZrTHwi7PZM8cg+cYFjLJQQwIgTRKrkW/p7AGSMC
	 sukYKaTHFLSjvG0eWpIugBjN8ggWDQaEfZvr6cn5YVVZetS4ceQDnzW9yg3f4jkvs3
	 Zkz5u7NQ3Pu/k5x4SbqGuPMtEsLYlTWfDvtkhbeO8zT9K26QMueWXbbGvvjrP4ynqf
	 TnKEsfjoFaHFUwX4Hi6XugBcIBLMbZDCMj35+2lrhABWpgIyuS2RzzmYK5gquMF2Mb
	 QBrJIn/hUDmG5X2aVVdLTKrXaGlIPdq6UhVl7zB+umn8dnNSGbVSL7JneMS/VF/Ktk
	 1FI608pRYiFag==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 83874C53BCD; Sun,  7 Jan 2024 10:48:09 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Sun, 07 Jan 2024 10:48:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: carnil@debian.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-2Tg9ptBnD7@https.bugzilla.kernel.org/>
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

--- Comment #58 from Salvatore Bonaccorso (carnil@debian.org) ---
(In reply to The Linux kernel's regression tracker (Thorsten Leemhuis) from
comment #57)
> (In reply to Salvatore Bonaccorso from comment #56)
> > #regzbot fixed-by: [=E2=80=A6]
>=20
> Thx, but this confused regzbot a bit, as it tracks the issue as a mainline
> commit only this is needed:
> [...]

apologies for that, this was not my intention (and cause more work)! I thou=
gh
we can track as well the regression fixes in the stable series with it.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
