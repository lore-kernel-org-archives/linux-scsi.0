Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B454F5C3D6
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 18:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UuldPKxj"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86FEDC433C7
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 18:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701281473;
	bh=SkwUbDrk1Z/UgqyNHyxJOIsfiwg4BJ4n9CStrtcDoko=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UuldPKxjuUNOEx6IM5W/736Vn9Ouf+FzvR7VGbuupI1qt4Qs9wvQQdhRF7UCh4fvD
	 c0GJiKVdn75oel8q+Ir9bMUqMlheGqOjPo2ybajudpehPoFUUye1cGodK+56IBJeZS
	 DcC33gQ9giMOSTyeoKvVp1E+ucqT5V6G8vg9i73mzF3vOp98fbiaMEdVs/2CzwYIjs
	 BSghxaEhGjHmyQJcyBgZ2GPcpC5oLlfrduveBwqsHN7bL9shLPp9qQ3jeCZXPoEOAZ
	 deURrcg8sQZ4tbrgzvzjJhIkEf7NeW8r40vRV1pX8NXGx2hTth3D9B/5MmbifdHG+x
	 IpdZu9TcxK3yg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 757BAC53BC6; Wed, 29 Nov 2023 18:11:13 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Wed, 29 Nov 2023 18:11:13 +0000
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
Message-ID: <bug-218198-11613-rm8i2QTU2z@https.bugzilla.kernel.org/>
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

--- Comment #9 from Dieter Mummenschanz (dmummenschanz@web.de) ---
Created attachment 305513
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305513&action=3Dedit
logs from kernel 6.6

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
