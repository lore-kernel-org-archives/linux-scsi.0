Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C685818C04
	for <linux-scsi@vger.kernel.org>; Thu, 23 Nov 2023 08:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="naWPjrC8"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51BD9C43397
	for <linux-scsi@vger.kernel.org>; Thu, 23 Nov 2023 08:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700726553;
	bh=00X2wuz3ZRptYTMmcB61p4uQh732BpXQ16bbMHHnu1w=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=naWPjrC8uae9cFwq1e4eH8zjxC/XRSh8pAoZ4PxqsM3Kzr+tWlHb4RkwR3yjXr+GH
	 3EUWyhh/7EvmTzr0jSLXyPsOYA4ghsahWfKJrNgVXqHip8PeEvgC5LfplmGVmpRBk3
	 KrVwAEfiOKLq0Pt9foDkv5zROJNpb2aQog9CJNe1FqngP14s9+mQTFXoFuzcfO9Gf9
	 JMWH2UI9QZ/bd3m5N53MLjiyLP/TJXfwpnVK9yrh2z9FGiOX7MJiSccTUAzpJdV2BD
	 BjnSGrld/ZS/8Xvx4NFWVOBc2oLUpiO545qkG3nr9hEMSw79sfbVAYKqdlxkhrU3gb
	 4W+I9k7c4+CJw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 4076DC53BD0; Thu, 23 Nov 2023 08:02:33 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Thu, 23 Nov 2023 08:02:32 +0000
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
Message-ID: <bug-217599-11613-psYIC6y5Zk@https.bugzilla.kernel.org/>
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

--- Comment #35 from The Linux kernel's regression tracker (Thorsten Leemhu=
is) (regressions@leemhuis.info) ---
Would be really great if more people could do what James asked for in
https://bugzilla.kernel.org/show_bug.cgi?id=3D217599#c30 (e.g. check someth=
ing
and if possible try a revert).

(In reply to Randy from comment #34)
> Probably of little help

FWIW, as it was not mentioned here yet. As stated in
https://lore.kernel.org/regressions/c6ff53dc-a001-48ee-8559-b69be8e4db81@le=
emhuis.info/
it's known that the culprit was picked up for 6.1.53, so earlier versions
should be fine.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
