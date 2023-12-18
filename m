Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEA814AA7
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 10:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BuzekOxh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F5EBC433CB
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 10:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702894844;
	bh=d34MNrhdSmzoN03WRPep+MqtI8+0eezR+z6tLvuF96I=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BuzekOxhGlzDVRDY+RkPRYW+xfd+8RdxXaM3hmXBp2Jbaiebn6X9A/Bh/TbEkwuUK
	 2ez9YZPlqmBfxIOPzbXKdMBHDUjeJz8oDia6l6oQwQhRXF0TSdQxe3LQ7gdMQfH4Nv
	 yApsNvsVN7qsOgqnIlEFh0ID/jhLyP644giv/pp43dSWs3gK738q4hejCxu6g/WInz
	 74nVND5AuYhQQYt8/y95pVP0QYsWs+if15Nyt4vcdkl6uHs+hXtJxe8eKPQbSIoNua
	 ZlkJMiHOAXizrS7NpVVFZDeGMYOCtEqd09vcvP3XMbB5Iwn8PC+UV/dG3TW6kHoSpa
	 r4ogUVIv63srA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5C6C7C4332E; Mon, 18 Dec 2023 10:20:44 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Mon, 18 Dec 2023 10:20:44 +0000
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
Message-ID: <bug-218198-11613-9xgHMIYPwQ@https.bugzilla.kernel.org/>
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

--- Comment #20 from Dieter Mummenschanz (dmummenschanz@web.de) ---
Created attachment 305626
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305626&action=3Dedit
hdparm -I output for sda

hdparm -I output for sda

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
