Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CE5CA4D
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 07:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i+5IMhWx"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67FABC433AB
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 07:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702884679;
	bh=mRt/gVlPCaeKzDPieZjAgqSY3X3QuwJq6/0nMF5BSZo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=i+5IMhWxBTq6pzEDkejdv1tm10iLpcvOPkN/w9FR7iOgDQ44nHRLvWN5veF/N0BLq
	 Ub6pW8DuI68L1Q9kjF7l0RFtZ4ckOY5EiyKqz95q0Fp7qOLnj45qmpakWS9VPMlnPz
	 bhMimPfKqWy81d2SHVkfYy7wluwbJAUWVM61wbzLeZnpK7EZvOclwbzGru1eeXRqAY
	 D4RYYJexpx//qIAnCxHPNw1wm/4DKZhHI5Od1UThk30pKsbSlBShDA1Asi9rxus2zu
	 V3WyfIhskanBE61Eqqobi9ngKKmABrwoaEq1CiMvAwYb/jMQsd+cUjBWIATBbnS93X
	 +bPoVARd/OOBg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5A413C4332E; Mon, 18 Dec 2023 07:31:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Mon, 18 Dec 2023 07:31:18 +0000
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
Message-ID: <bug-217599-11613-L7UJ2Jt2eS@https.bugzilla.kernel.org/>
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

--- Comment #52 from The Linux kernel's regression tracker (Thorsten Leemhu=
is) (regressions@leemhuis.info) ---
FWIW, the revert is queued for 10+ days already, just sadly was not sent to
Linus yet:
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=3Dfi=
xes&id=3Dc5becf57dd5659c687d41d623a69f42d63f59eb2

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
