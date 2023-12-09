Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9218D372
	for <linux-scsi@vger.kernel.org>; Sat,  9 Dec 2023 00:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qCM/S60F"
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED6DDC43397
	for <linux-scsi@vger.kernel.org>; Sat,  9 Dec 2023 00:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702083391;
	bh=MerrhXtCFz6VZKhUR62EH+ylEf5ZTWzmVThcLKOi/4g=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qCM/S60FQO77J2RanHQkW5AtLxaBE/CaUIPUPh/954trS94g5Ds9+3MGQeVYlIzAm
	 z5rRDqpPHJE8ZT0gvzDlJsBaVUwN0+3ElmL2HMQirrS/Mdy2v57M82NWX7nYLFABac
	 OBJkCP6ZR//Nxj8xy/eyJw3weo2GultXFbQuaHkAZiM5/ipwXL11lSGaUD9MZEcrh/
	 4QWz2Szy64BLYKpSpU7gbeIKZcIrJJgiA7IiLckopvspP6PwyTIfPCXjRQOHIFD/eN
	 c/DG1fAFirJJwfTYYYsxhYXzBJGm8wVB/en2to1zu/YS8eimHX4DI7qP30F60fIGh6
	 DD4SEqdXUoehw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id DD276C53BD3; Sat,  9 Dec 2023 00:56:30 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Sat, 09 Dec 2023 00:56:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sagar.biradar@microchip.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-LYwvcexMIp@https.bugzilla.kernel.org/>
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

--- Comment #45 from Sagar (sagar.biradar@microchip.com) ---
I am looking into this issue actively.
My efforts to dupe this locally on a machine with 2 CPUs is underway, and I
will keep this ticket updated.

If we happen to dupe, and find a fix - then we can consider the patch queued
for revert with some tweak.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
