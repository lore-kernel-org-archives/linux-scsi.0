Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A698592E
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 13:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709645557; cv=none; b=kKiOyMsW4XD1w830zX/1D64JasuO4jNVnR0g4X4vtFaN4Lvks+wErxvlzONQdUAImsDqJmXCjkrKJBtdiHXlCxiRqQBZF9GLWgtzCEiCT+ILPZZeBUydy0IlWOaV+SC8ArT5XBcgM31n79WaGOdUi1aK3eiyUBdp2DLiiUkBIlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709645557; c=relaxed/simple;
	bh=9JiC8Y+QdO7roIkA3OqCJtVLQIs4KmmlSQlUc/tNzL0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K40sEMRbpItEygtKVY2xeeq3tUkuadRykprQ4ELIcpIxn7pOLlekgWQuJ+HHFhFVslVwsbpXGGZA7SQVuEsWpGF5wtW6DndSTR86K2IoB3RS83JtOwZdJJL1ZRp1ELD9em8vHmej6sMI7f21rSFpm/K0vVgcnlbKunASK99PYGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uhlla6sW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uhlla6sW"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C031AC43390
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 13:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709645556;
	bh=9JiC8Y+QdO7roIkA3OqCJtVLQIs4KmmlSQlUc/tNzL0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Uhlla6sWSQCORnDHX9N0ME3TL6rwnb5fZlMhbS3tmzdXrNpSydPqan/chcnuPcrQo
	 oze3HvDn97gXROuUww1ik/o+oxFCj5dXpccsXxtuTBfDvXduY8/5srNmXW8vz6Dd1n
	 Jn5b729tdXdabUg4qOlFpROB63u2VA+5O0+jZ81dWlfsJIzotHRSuYlWaFTIqrhXH3
	 99l1hMpCtCi1zaYOJj32Rw2ROaeB/sV4g7K7blg6Enf7q/JmHSj+CvzzgggnlGaq1b
	 5HwV5fXkYnPDK+e2vD1g9B4PPpANpnTUOigF+NpqNrghO3dEhdjaiNyYnIJIyHF0oG
	 clAa51g222cgQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id ADBCAC53BC6; Tue,  5 Mar 2024 13:32:36 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Tue, 05 Mar 2024 13:32:36 +0000
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
Message-ID: <bug-218198-11613-WdSeXPP22T@https.bugzilla.kernel.org/>
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

--- Comment #27 from The Linux kernel's regression tracker (Thorsten Leemhu=
is) (regressions@leemhuis.info) ---
Dieter (or Damien/Niklas), what is the status of this? Was this fixed?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
