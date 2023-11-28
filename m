Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B2015AEA
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 09:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NolfkGvq"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34A58C433C9
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 09:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701165298;
	bh=8L3/V6sfVSbp88B+THpMPMcTvh6JcQW6QJW+nWL/jbs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NolfkGvqYi5BYLV4ZOD8u2G00U6P8lUNEK0gYXN/z4RvRNq2MXbcx5R54JvmfSIKZ
	 /8RrGbYUgL0HBjaE+w6c1M8RcY/ogHBdT2Frxh3U8LXr/njp3lTgxFwffjIqLDO4Tq
	 RY5kv4vyKDGbugMB6skpX8SR33Zrbli8NvCmAfHbfnGu2XpBC6NlynyN4dGLHS+vlH
	 mFwlRc8ZZix6NFEtP3SSahwKKsxs0CgSy04Xu9plQzFysBBMBGO4UuLXiYcjl3eKd4
	 Egdj2O+NWCpWFLZPaeUjb2V0tGRzPsWa08sAzwga/nwF5x+pim57hc90D7sQsXR1+G
	 ye+HB8NUgWdEA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1E40DC53BCD; Tue, 28 Nov 2023 09:54:58 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Tue, 28 Nov 2023 09:54:57 +0000
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
Message-ID: <bug-218198-11613-ST2kw9wMKW@https.bugzilla.kernel.org/>
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

--- Comment #4 from Dieter Mummenschanz (dmummenschanz@web.de) ---
Update: Please disregard my last report. After a second longer suspend I'm
stuck at pc2 again :(. logs attached.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
