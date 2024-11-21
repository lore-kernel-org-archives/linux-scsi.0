Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010F413E3F5
	for <linux-scsi@vger.kernel.org>; Thu, 21 Nov 2024 09:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732181533; cv=none; b=C347+CXLj0yP864hhB6pWyEAdIn765AQepOFzGkChVa2W9z3HJabodPReioDH/l1wx/wWIow34npwY+0IUqZyOOrWYNlo5xuQXNAYpn7mvBFUvHgG+V55dV6Km8jBUkyjm0DLMa4T0pjnO9Jslb97LXwwGk+2QNflx3eK4ahFTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732181533; c=relaxed/simple;
	bh=9MDy8GeVyqN55EXTZYBy21ZFY6ciZNVXhLb46hRk//c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VWT78Y+SQuP65mIY+g1yiCxW3wm7BGXNNoG7hKcYo9j0KbrpuvpbddW/wk0vBzVtXEb+yPuQE/XSDmstw8+gRhR9r8fQGLpj4NSzLFSM73zVHbtSWYX98LhwptfA/ZkorGEEpPLavRjxl7u8Buv+9UBkgRXnvw0s2xykxUHmDWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W2Nr0MLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W2Nr0MLB"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73C2EC4CED2
	for <linux-scsi@vger.kernel.org>; Thu, 21 Nov 2024 09:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732181532;
	bh=9MDy8GeVyqN55EXTZYBy21ZFY6ciZNVXhLb46hRk//c=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=W2Nr0MLBbNCnV8jCVD/bLTuPvIX/wCVhaYRhXFVdTrA1qDs3XwgZ1S2rfDxUVeoXh
	 viQodup503b0eT2jZGvaNYOpErn+FaU2FEiURJw+cyv4esbcb91hiPnuDd8xgkf3gA
	 XggKIMZyN0qFCTbA2x9awyhUd+RN7Z2EBUcEI+bEe1X0rnx6F/WpCwOtbV0YSAldVB
	 qpwaLVg9/j4lFL/z+8c2vX4MNfZ8Sba/opRAIJAAGqWHwz9FPpimP428XtVZfTbl4M
	 x/MohhluRNrLyOrUNU1bsu2sVBih+5B6ONlPSi4/Ni4yoGtYRhMx3luXAoVdg4oGLF
	 8yK/r5Kzd01cQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6455FCAB786; Thu, 21 Nov 2024 09:32:12 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217914] scsi_eh_1 process high cpu after upgrading to 6.5
Date: Thu, 21 Nov 2024 09:32:12 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217914-11613-dunIpaxVOL@https.bugzilla.kernel.org/>
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

--- Comment #11 from Fabio Pedretti (pedretti.fabio@gmail.com) ---
This should be closed.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
