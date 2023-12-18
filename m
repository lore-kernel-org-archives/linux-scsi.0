Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1149114F61
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 10:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jz/EIAGo"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8AD64C433C9
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 10:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702894904;
	bh=Rq6WbgDxFf/0q+c2d2+3CfLPHWFVJr/FPUHg7eQKlM8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Jz/EIAGoJxYaWQBFc1pVPskIf3/KMhdS4AawWPufEEHbMARcoOf6ZfQtQzYLUglQe
	 vUwc5N3ITI9S8uzNamjDTZx1Te+SxmaTWBrfZu9A++KqpmUtQqP0tfbM4HQFwj1jiT
	 iLi96XSA5sfqmXt4IvAM4I2zJWw//hNfR0Hxmtt5uOZw2JP3PpPOjZPeK7NvnackOV
	 9EWbGY2mRVjN0WgElU917oVVKFH1FoqpHpjmld4PnuprDgiH/1+IaguFv/8dTxtD2M
	 LvnRZPeCCg9uAwl5DtJ3pF5EPjY6f+kxDJU4hAXZ3hSaK65iZuOypWRJhwv4aY8Q8E
	 PuM8mNo7anQWg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7BC1BC53BD1; Mon, 18 Dec 2023 10:21:44 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Mon, 18 Dec 2023 10:21:44 +0000
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
Message-ID: <bug-218198-11613-KjqP8simBp@https.bugzilla.kernel.org/>
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

--- Comment #22 from Dieter Mummenschanz (dmummenschanz@web.de) ---
Created attachment 305628
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305628&action=3Dedit
dmesg with no pc8 transition

dmesg with no pc8 transition

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
