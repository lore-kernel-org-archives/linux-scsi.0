Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CBDE570
	for <linux-scsi@vger.kernel.org>; Sat,  6 Jan 2024 19:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l/Bc1ud0"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0846BC433A9
	for <linux-scsi@vger.kernel.org>; Sat,  6 Jan 2024 19:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704569914;
	bh=hhfuyT7vASDI4V2KILIYSEyNh5oN9OCJV3354iI54NU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=l/Bc1ud0iy912zaC8OY6zLFk/INWWZvtVA57RtjqkxGkiv9lGI9YZ1kCzqqcc+QQ4
	 nPMYQu4jd9l/mm+KDJXA+MQq02QJXAC575vkXJMzYQQymfqyXLL1yzW9z1H/SdN9oU
	 3nS5SUSCiuiFKq9v5IFgzBTStcORpLtePK4+SBG9LNJu7JVyCRwHH/L2fEv8hV22y2
	 zM2FR+MWVyM/527odtl50CxOM2W7A87WMBEe7zHNAa3t3MHY+fNCW+IimpoAQJIEWt
	 6qZ0WlYxn2x7x4Q80iQmuAmkvkXiEDoz4SNxLe6uiI8Yx2/85uyfOle/VxN3Yaj9U6
	 nV//V6toHXDkg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id ED26DC53BD0; Sat,  6 Jan 2024 19:38:33 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Sat, 06 Jan 2024 19:38:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: carnil@debian.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-QiHCN7Mxnd@https.bugzilla.kernel.org/>
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

Salvatore Bonaccorso (carnil@debian.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |carnil@debian.org

--- Comment #56 from Salvatore Bonaccorso (carnil@debian.org) ---
#regzbot fixed-by: c5becf57dd56
#regzbot fixed-by: 71758d4d87ef
#regzbot fixed-by: 72e472a91c0d

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
