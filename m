Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1AA15AEA
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 09:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oR/OInA9"
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF1D7C433C7
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 09:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701165350;
	bh=NGIz8AzeUtFTU1eCoN8RDr5VIKLEsfbEZfQB+tC6LDE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=oR/OInA9X2yazBDIYagJwu1jfdTii65H1oB3EjX5DP6AHx/4JyVIFw1wN+kaUBTmT
	 s6KSwVBUXPT/kScYmj01Tl0g/9hAfawI1c+WBA0MqqYtPaHxadyPLeFhnEOfxhNTlO
	 w91upmtPNd5WuGlzbEqHsjnNn9XMNJVyNnwBXwe9XrZFzVDC6jupxO/uPhR4fJ5+LC
	 0MpcCMkRm3u4M81xsNNoeDcWgz3I7REtqTSvD3BiSAI+IcRtPNgobkrfBf35Eu5hVa
	 g4DvsjwoRpDE2EhlUeaHIxKeO6yGwqxBbRAcT82DhPg2AMj7KqMkVpbC+eeZnaC9eo
	 jV62cgcQh/PHA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9F40FC53BD0; Tue, 28 Nov 2023 09:55:50 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Tue, 28 Nov 2023 09:55:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: dmummenschanz@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-218198-11613-9ZRV8imlQg@https.bugzilla.kernel.org/>
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

--- Comment #5 from Dieter Mummenschanz (dmummenschanz@web.de) ---
Created attachment 305491
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305491&action=3Dedit
dmesg partial log stuck at pc2

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
