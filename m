Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AB0441A
	for <linux-scsi@vger.kernel.org>; Fri, 24 Nov 2023 06:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H2FFIYY5"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59810C43397
	for <linux-scsi@vger.kernel.org>; Fri, 24 Nov 2023 06:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700809100;
	bh=HCgUMQoywohbWiGHw51GNave1etNA9Oy/d7h6TaH278=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=H2FFIYY5OoZ5+T+wLHxv1VN42m46chBCwrXflscwNxSvGbWv43h9Syf0f5dqpgQyQ
	 qhC10NYoG0PRkridfOLAnX2Q8vop8pB6cJoCoH2VjMReIfOtuLScAOkzHAt92nQcJo
	 42gniCgXTfbTfGVYIXtzWoUns0kaw6vxNW4OZzRGEtZfaDvxc6bDBxsYqHeFOB60EK
	 7JeCesrnP+e8kis61N8atTI+tGrUZI9+EWrUu39C9aAk5W6p3kcHFmVFZIJUUYe7Wq
	 KBIEmyuDWMaqfycvmaPExcRCMoNU2KfVAIoLp7xreqKeZat51cdeAqwJDfldaTTkow
	 cVOFTvXMzx6pA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 498DAC53BD1; Fri, 24 Nov 2023 06:58:20 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Fri, 24 Nov 2023 06:58:19 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-RtZOz58dkr@https.bugzilla.kernel.org/>
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

--- Comment #40 from Hannes Reinecke (hare@suse.de) ---
Next idea; can you try with the above patch?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
