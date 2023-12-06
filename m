Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E193321AE
	for <linux-scsi@vger.kernel.org>; Wed,  6 Dec 2023 13:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+bv6Oax"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E604C433B9
	for <linux-scsi@vger.kernel.org>; Wed,  6 Dec 2023 13:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701870737;
	bh=MoEgowtYb4oLydX83qUc/0T+ebvbT3s3J7Q4eY7gytc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=b+bv6OaxMxt/Rn6KMSi6iXmqw3ewF3LSQRA+h7GzZbCv/Eo8iwW6X6QaFNkM0ZLSp
	 nhDwAJFwMWJYneW9Xjevigx38TXINP8qVXyxefFBGtSIxxRteqLfgaVMWyepi59+8d
	 XncXnLVXe1Z+0IEj7KakUV4SveAR1ONNIYBDZB3vnM2BEInsqt4FdbtC4W1gW5wew8
	 YpRozpwOnxQhwgXafz6QOyAAJ6x4mQfvqHUTUUgBqffZD2eLXIdcuQBMr+1fBB8xUN
	 LqMIijHaTzf/RzfNhAU6kvoFWB/4cSS7CjrFd0pKpQuRzUnFv/GiOrih/+n8pM3/bP
	 emn6c63XyOomw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1F83BC53BD4; Wed,  6 Dec 2023 13:52:17 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Wed, 06 Dec 2023 13:52:16 +0000
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
Message-ID: <bug-217599-11613-mRUtjdlFXT@https.bugzilla.kernel.org/>
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

--- Comment #43 from The Linux kernel's regression tracker (Thorsten Leemhu=
is) (regressions@leemhuis.info) ---
So it looks like Hannes' patch didn't help (thx for trying!) and things sta=
lled
again since about a week. Anyone still working on it? Or is a revert of the
culprit slowly becoming the least worst option?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
