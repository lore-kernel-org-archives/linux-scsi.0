Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8CA156C0
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 10:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QzttiKQP"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16101C433C8
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 10:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702895816;
	bh=L6g6k2zD2tFM3WPYVKZi328bycJVWe3ypznGF8NHLas=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=QzttiKQPQ2Rw+P0mNFfWf0jOBCcr2vpScxowEA4y33TS+0uhZpsSlrS5LxctCmL5X
	 zimvtf1ZhVaLo24WLjK7YnT/xpfVS3hokpRTzYBqgRrbW/Yye9A5+4xlfuTosQWviz
	 YFMjxwy78y9Ak0EXx4gsef3SkU/aQwSAUihIUnaZaCoVmcxAq42hxjNS8qK4wIPSeD
	 gYrJMxbXSg5LErL3s4zF/5wDR4Y1bHB6R0u7IucyVi1yefGWuX8be4e2tV3GF98Pvs
	 FvQIiNMtBlfkE/M/5u6cf/fkaIGrw4rQ8MyZR+cLZBmYLAnQDkJ3UhhQigxoC8vcch
	 QkvmCM4VM8J/g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 05352C53BD0; Mon, 18 Dec 2023 10:36:56 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Mon, 18 Dec 2023 10:36:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: regressions@leemhuis.info
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218198-11613-irG8pe12en@https.bugzilla.kernel.org/>
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

--- Comment #26 from The Linux kernel's regression tracker (Thorsten Leemhu=
is) (regressions@leemhuis.info) ---
Please also include the regressions list:

Linux kernel regressions list <regressions@lists.linux.dev>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
