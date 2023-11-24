Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599FF441A
	for <linux-scsi@vger.kernel.org>; Fri, 24 Nov 2023 06:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BOYWQZSC"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0567C43397
	for <linux-scsi@vger.kernel.org>; Fri, 24 Nov 2023 06:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700809073;
	bh=/kCDJB37nvhFSIBwSK9HLgPTuPnYx673gTXE06J29co=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BOYWQZSC8yq8+KFWT6vFzBAy34WEr6g8GuTG69mHgK7umn7dmYoG6R0VwQWDfzDS/
	 d0CT5NDvmNh7aprzalSEwsUpMXQscgApoJN7ejvyr5YpHsBP6R0+arU1U8zb4mUbHb
	 qXF9ZMwN/kIAEd8QfSbxzJ81KunGXcf0T4G4bNuP6kLO0TY6wcmt4pb4Uzg76h2GSL
	 WF1NKC4Kv/q4V+VLmdTkM7DMCwG5l1U4yXWFKNTGGqjUPtYS9445OEsyj9TBqsCgZk
	 rtvRcnbJWyiPZXFYRIIPMs/jcVSMx2XE+C8fidyiO0ukdEh6chjRnGS8UOH4R8Nsut
	 8ovWRHzjgDSAg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id CC25FC53BD1; Fri, 24 Nov 2023 06:57:53 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Fri, 24 Nov 2023 06:57:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: hare@suse.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-217599-11613-yJ8JXy4oW8@https.bugzilla.kernel.org/>
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

--- Comment #39 from Hannes Reinecke (hare@suse.de) ---
Created attachment 305466
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305466&action=3Dedit
0001-aacraid-fix-vector-calculation-when-submitting-command.patch

aacraid: fix vector calculation when submitting commands.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
