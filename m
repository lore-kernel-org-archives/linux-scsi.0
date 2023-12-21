Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38268156C3
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 07:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bzhn80f6"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0142C433AD
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 07:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703144996;
	bh=2xjNo6Yl8YqAaPvQ+NCCAgpfEQSexoj4BCACOYMsQB4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=bzhn80f6wDNeT0R8a4ug0BNZnhf0LFWVYv9hLREkTQsEpiou3x0Y31nNjjV9/kvOB
	 yIdzdi4/vf9mWUxloT0wssqn6UBF3WnRFszafoNjoxeSL5gK8GA0w75E3sRwXLk8eJ
	 TXpUBifvxKQM11/hPDiGR3msVAKNNYAmGym0wkAumHRlXKOWFmBJoVmYByEqP/so4E
	 chG8I3zp0amhSLeZ2V2uWKe5tDSL6FL/Ic/TO4DUCj9P9jj+8g+rHDI2toP67poX4n
	 esxsf4sh9/wRm8bhy7RUBpYf4lQkPL/YewtbCN2ZCL2CHS9giuii+LlHbH0CVDmTpF
	 4P5gHX/qm8/9A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A10CEC4332E; Thu, 21 Dec 2023 07:49:56 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Thu, 21 Dec 2023 07:49:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: kernel@gz0.nl
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-sx1qGFtMYx@https.bugzilla.kernel.org/>
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

Rafa=C5=82 (kernel@gz0.nl) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kernel@gz0.nl

--- Comment #53 from Rafa=C5=82 (kernel@gz0.nl) ---
I don't know if this is exactly related, but I got here due to the dmesg
matching.

I'm using a 8805 card, on a Supermicro H12SSL-I motherboard and an single E=
pyc
7302 CPU.

On 6.1.0-15 I can't boot/mount a dependent drive (this error happens).
On 6.1.0-10 I can use my system fine.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
