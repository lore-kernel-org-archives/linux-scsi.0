Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70187249EA
	for <linux-scsi@vger.kernel.org>; Sun,  4 Feb 2024 16:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707064652; cv=none; b=r4ekGdsj6g19wMa9g4RsCVyEBVjOAgNTUQ+4NZfB8KhvHNjD1248I2s38gZkW3XigILin3WAPu5EBnrTGbYAkDDavVksxomjvLPmzOLc8txdZ3xankfpXYQdE204WxPyLa9QzuRsYgOxcQrt5NX32GnoY7JWFWaY7YxUrJIyQ38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707064652; c=relaxed/simple;
	bh=tP0h2EKwPr8gm7U7oGpu7NHc26S5yKalkeuOrvWbyus=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=izL0/zHd6dgSJzsApqa1yxPV3pw+EN5YyD2ShPZKAV9DILF/E5bgQl0LR+j1bMVd4NLlNEf0kQBDzLCB3bn0xY9dxWZM7juO5yKSpbcugTIfQSuhw6OQEXpkfebB31peV2LBL/MPCQKto0On1Y9/QzMsri6/NqOvvGQD1E5HmwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uF0V7yxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uF0V7yxd"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62F07C433F1
	for <linux-scsi@vger.kernel.org>; Sun,  4 Feb 2024 16:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707064651;
	bh=tP0h2EKwPr8gm7U7oGpu7NHc26S5yKalkeuOrvWbyus=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=uF0V7yxdRfYuSuKA43eVrbMbysE2p/SM1Ya/7yEMaHknjGQXng9V1hn8FlovUaCGJ
	 Gn1tv8vlNpgV680Ea2HHtPaEI2M3e6KJ+tH3e64hn49yE6ddeRR4o9u/t8o/HlCgxi
	 Up7OGF6Nfn3FRF81EeO7E2e8eBCz6FkbuvKx79brORBhYzGp/JtVoRYclevYmo0hPB
	 mb7C3UK3pqI7jlnpNAHJ3fNNhGJL5ixVwInRZaKJcBbUM4tjjgupeyrRlwcIBrvZ6b
	 qi3c/nOalPZw6nejhSI1+Cx0wkb2FUCusZKsRPIOeGPVT0/PvpW0DnlVk5faTmsaA7
	 wRZIYr6yvFCAg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 52AE4C53BC6; Sun,  4 Feb 2024 16:37:31 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218457] mpi3mr - mpi3mr_transport.c:1818:1: warning: the frame
 size of 1640 bytes is larger than 1280 bytes
Date: Sun, 04 Feb 2024 16:37:31 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ionut_n2001@yahoo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-218457-11613-s5nAxos4Ut@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218457-11613@https.bugzilla.kernel.org/>
References: <bug-218457-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218457

sander44 (ionut_n2001@yahoo.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|                            |6.8.0-rc3

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
