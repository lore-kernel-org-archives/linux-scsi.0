Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B7010963
	for <linux-scsi@vger.kernel.org>; Mon, 27 Nov 2023 09:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dbhucUAV"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92B7CC433C8
	for <linux-scsi@vger.kernel.org>; Mon, 27 Nov 2023 09:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701078626;
	bh=TmxN4+lK894g8ZNbTNSgt0YB0kqQd2Ry90u8Oqh9RTU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dbhucUAVSTdhiKxsQAnCbBfBf0AkmqBFE7af7mky30CBim3tTrlUajsSi9chU4gdr
	 bBbENgIfW5vNw/fGFlq/JJL2mgaLS65s6kBpAc4ahf+mAMi+Fn4Q1bva3zCMwDdbEC
	 4GqWEx1lNkUty9VtWotU1TMvR5FH4BoCYRs/UyHzeCZNRc+Cffq0vKGb9vmbLJfQ7U
	 TP8L/DsfeDY5e7nl3zt9SRW3fe1LiZqPha3r5ZKDfRJ4AiZp6NmAyxXgVXpk4qQBCb
	 fLDVNMQTbIW6+OUqawbIoG5ko8Kum/+8KIRvzr+XOKv6ZN294UWBQebaD4u3Fgbf/R
	 cwsdYOCXghZ6w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7C69DC53BD1; Mon, 27 Nov 2023 09:50:26 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217914] scsi_eh_1 process high cpu after upgrading to 6.5
Date: Mon, 27 Nov 2023 09:50:26 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: pedretti.fabio@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217914-11613-Z64rkoaJeM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217914-11613@https.bugzilla.kernel.org/>
References: <bug-217914-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217914

Fabio Pedretti (pedretti.fabio@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |pedretti.fabio@gmail.com

--- Comment #10 from Fabio Pedretti (pedretti.fabio@gmail.com) ---
"scsi: core: ata: Do no try to probe for CDL on old drives" -> it's also on
6.5.6.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
