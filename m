Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03541CF94
	for <linux-scsi@vger.kernel.org>; Fri, 24 Nov 2023 12:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="petFFAIn"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12031C4339A
	for <linux-scsi@vger.kernel.org>; Fri, 24 Nov 2023 12:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700828385;
	bh=rImdZ92OFFL1EQC/LY3hNvVBQNwsS82QVDU7QUjaCnk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=petFFAInal3bqPd0nVpqdhw1a5Yr7jekVg9UhoIb++QxdhvKPcz45vStOFTEUJ0/0
	 Pp+q5N1JyMlbyWoKOcogEhjRvh8wiKpRH5tKqadqPVyLfDUMT9pX4k+Rlxih5VFO6k
	 l+jk1rbbzGndzFttRQ9pWgDm3kjwWthusPTTs91kAu34Kfa6D0Kn7/pMtbIfnEoqQu
	 nGxGlDEV10tMd06UiEsqkUzevDqKpfB/CMPwV3bQkDZXxjjL1rLMlkFrBp5xeM68DX
	 4yXMQ3MTF6Wv3JtGVFkmMhudGJq0PrQawZC9sSFIXYPqt8xzuJF0o3OcnkgtgkG39j
	 AN7//vG50mL5w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 00FD5C53BC6; Fri, 24 Nov 2023 12:19:45 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Fri, 24 Nov 2023 12:19:44 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-217599-11613-VLbI0HU0lf@https.bugzilla.kernel.org/>
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

--- Comment #41 from Joop Boonen (joop.boonen@netapp.com) ---
Created attachment 305469
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305469&action=3Dedit
Test result of
0001-aacraid-fix-vector-calculation-when-submitting-command.patch

I've tested patch
0001-aacraid-fix-vector-calculation-when-submitting-command.patch on vanilla
kernel 6.1.55 .
Doesn't boot properly, I don't know if this patch should work on this kernel
version.
I've attached the output of dmesg

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
