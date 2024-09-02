Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D5081732
	for <linux-scsi@vger.kernel.org>; Mon,  2 Sep 2024 08:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725266895; cv=none; b=LN5lWRBkTS2DYnnpJ6TGsQ+fCB5MRJjdQ76dmHUY2Qae35xNUs2/Is9Ku5b4G8fdOFiwwT37gCsNZ/r71BRQOmhoCMfULEX9NZSFttXi3gH8ZpvnAm+mYBmMocYNOSUT7JG6MIxUNjyYyBbEwmEual803UE8bK+Ioj2bn0oN+6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725266895; c=relaxed/simple;
	bh=iA+MxXV6xBRQzqEjowyo4unqQOfNNVvB7CDEXOjQaGI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=os0TCW/MVF0Ulcdt9lMIWeVhNuhsY1vFiGe2Z69dBrOenOZUp9GoS4QGDImtqtldi6R2F8ew7Kq8H9++VQg5ZRSVHKebhzoyxDBfkTUy9qKhGI30lI10V7I5RYd/bJLO5aUQ9Sv3d86CKt+BCf3h36gzgVv8AmxASA0/NlakMXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IhCEalv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IhCEalv6"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4FA27C4CED0
	for <linux-scsi@vger.kernel.org>; Mon,  2 Sep 2024 08:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725266895;
	bh=iA+MxXV6xBRQzqEjowyo4unqQOfNNVvB7CDEXOjQaGI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=IhCEalv6ARyl2n0K/z7v6GS588e5wBBA0BcDxJL9hrgNWhE9A0HDRYkikMcNtVMQy
	 o5jn5/VRC2h+w9k3w0JLRNd0WBvruPpYLpTE1ryMHyqsRQ7LI++S1FmiiLsh5MDB1t
	 lL81QNRzlMbJmrTowBS7zq+4tVpyiYpbZxoJteXuin/oFs4Eu8+RlFIBM2pESvll0q
	 qjF0RVRi0+VxElw58CD+nUsShBAnC0zten8u/OM8i78Odgh0t+8k1ToYREad3idJQB
	 cKWL59IsuEPpQ0qIUg8SX00PdaGbCX+NJIZc13t4y942IovrOqrEkACpZ2lqExUU0L
	 lKIlkz8kRxH1Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 474ACC53BBF; Mon,  2 Sep 2024 08:48:15 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date: Mon, 02 Sep 2024 08:48:14 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: hiyafe7592@ndiety.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-213759-11613-gJgEy8vSzG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213759-11613@https.bugzilla.kernel.org/>
References: <bug-213759-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D213759

Sanchez (hiyafe7592@ndiety.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |hiyafe7592@ndiety.com

--- Comment #15 from Sanchez (hiyafe7592@ndiety.com) ---
Magque: The Intersection of Digital hosts regular events and showcases where
users can present their work, gain feedback, and network with industry lead=
ers.
These events provide valuable opportunities for collaboration and exposure,
helping users to grow their careers and gain recognition in the digital
creative landscape.
Read more: https://getreleasenow.com/magque/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
