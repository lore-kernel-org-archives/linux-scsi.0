Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE916F30A
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jun 2024 08:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718007162; cv=none; b=WhOrpZU08doJgEVvUcUaFzubFhU5p+uAuWZQtiMGAainedV0vDiheDoUym77t8YcEmXzhIuFZQqnBaGEcqn8TCWJl0R80i3K/1J8ke0UOWe3jspfLp+MkdRQFaC6FkvaFxaL0W/kK8RhqqlBQkm4lf7/dyHvrHBJij/BnF5w4TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718007162; c=relaxed/simple;
	bh=Jy7YEvMELyDYrSUz3/aqzbupvLhtI58eVdIQEhlLivE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DgzUfekn2ztwTsxkh/C1Okb84I1CKjxlHiLsIXR5FTqxY9d1e7BCt+T0zkUjn2dVepTrHjEw6pmOKMTbT6V3EC6HT7bkoR0h4SNnPKeroKYjz5+kajC5pJk++MDDxj9VuNP4XLuPk6gkfM1yO98LhMW1ChS3jY+NAGOL5PVImpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JqbQU+5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JqbQU+5z"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E10FC4AF55
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jun 2024 08:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718007161;
	bh=Jy7YEvMELyDYrSUz3/aqzbupvLhtI58eVdIQEhlLivE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JqbQU+5zAR5Tq4TOYPEIBBR6lVwD51jthETTF4HfxyvIdBPBKozsstBOd1BmAWtO/
	 Ee+i06jCIqCDPnYb6tHMW5jctBG2A/2lnurdP41s4A0tkrOZmv4JLYvqO8VtV892H9
	 yr0CaQNHnF9jrOoASj5eK9MRmpvUDm6PzKgfmJJrdZMWmC2/pj9KGfFkVpkLYoiQAz
	 pmLGl7Z4kwKsn8YLKLfpm9VTlhhFPvg0SRySnqxOPwCzy8Wxee3p8bbCDl+eTRwa4l
	 bqb1zlv24PaPLbwWKWNkzButlaZNC/Ktsh9A7aHmArzjgEJE37BCnTz+GXdJBAQ0E4
	 DzFv6YbO/pKHA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 58BB8C53BB8; Mon, 10 Jun 2024 08:12:41 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Mon, 10 Jun 2024 08:12:40 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: Sam.shahl37@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-60758-11613-vywCQ9Oy1v@https.bugzilla.kernel.org/>
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D60758

--- Comment #63 from Shah Samir (Sam.shahl37@gmail.com) ---
Thanks for prompt response @Jamie.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
