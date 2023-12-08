Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C53338F8F
	for <linux-scsi@vger.kernel.org>; Fri,  8 Dec 2023 17:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UOldv9P3"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 076CBC43397
	for <linux-scsi@vger.kernel.org>; Fri,  8 Dec 2023 17:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702056051;
	bh=y0OYDUcC3DllxPrKgOa1vWZILTFmGC3qjxtKNX/S2JY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UOldv9P3RP8ecGHBU8XcTmWYN6LRzUg0bp1mpEJJ36LlePi3M9bWitp1r0QJByj6F
	 QolNgnuZe174PT3BQskyDwu1NdMo50Nz+vIE7STYn9lPjr05gOijjkEsU2nbuSvaNy
	 D7IJqXhyLvfzDkWQ91rvjAHSihOCIGlLrSVGC2PQ8RP2D1mV5BYHsc0BdWG7hvSSv8
	 WeI4seEHGp8wsdeKR1NKsAlQMLQLxDZYuZXlM3E/JGCkzY24Qn2IlxMakTvXt7pQxX
	 FzIcMx2Xsb4n2TG2+1wq7+VBXk/HgtLd691JKfQVDSaOhwj7d6noIierm/cMRm6LlN
	 srf9LVKicn6/Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id ECE62C53BCD; Fri,  8 Dec 2023 17:20:50 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Fri, 08 Dec 2023 17:20:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mkp@mkp.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-MuJaIEiaHu@https.bugzilla.kernel.org/>
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

Martin K. Petersen (mkp@mkp.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mkp@mkp.net

--- Comment #44 from Martin K. Petersen (mkp@mkp.net) ---
Looks like we have lost momentum getting this fixed. I have queued a revert=
 for
now.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
