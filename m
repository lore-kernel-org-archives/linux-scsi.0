Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FCC2D601
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2023 13:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="urLmVy4g"
Received: by smtp.kernel.org (Postfix) with ESMTPS id EEC0EC433CC
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2023 13:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700573700;
	bh=F7UhFKfCKK5Bj4xOZ6fI33H2PoVSvJnlHhvYYHTubIM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=urLmVy4gGUxHcmNDd+2hT0/MyC+sOvrNn/LZ5X/XpzYTeyZcsIWpUHjWVd2iEQgix
	 +NeCSezbFM5baG0vWduBMvgM4zIiAIBcMbYWD2DwqX0K5AVDlRdLo7wnrpphtzMCCW
	 IBjp+ESZUNiKriqpAQbTYkegtwluIPDSt3NWHcZXecJxEpy3G9AxmwMAm5oavMmjtb
	 iRHCI2ot1PaUWcqehggLvl+RYJt8YtOmw8NkEC6z+0ME6EdDfGiV3fp4baXlNg6cxC
	 znUSx3sUMLO7FKm7FnSqhMS5w9pjNE437R5q0PJ23rPBV/pZ8z9zpTXhm+WponEaXT
	 gSdOnAZSinL8w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id DD3CEC53BD0; Tue, 21 Nov 2023 13:34:59 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Tue, 21 Nov 2023 13:34:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: joop.boonen@netapp.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-2haeDcmwke@https.bugzilla.kernel.org/>
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

--- Comment #32 from Joop Boonen (joop.boonen@netapp.com) ---
Comment 31, has been created as request by
https://lore.kernel.org/regressions/c6ff53dc-a001-48ee-8559-b69be8e4db81@le=
emhuis.info/T/#m10c915e76ffc589585727f7c2288b213202102b9

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
